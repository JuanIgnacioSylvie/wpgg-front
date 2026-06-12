import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core_web/firebase_core_web_interop.dart' as core_interop;
import 'package:firebase_messaging_web/src/internals.dart';
import 'package:firebase_messaging_web/src/interop/messaging.dart' as fcm_messaging;
import 'package:firebase_messaging_web/src/interop/messaging_interop.dart'
    as fcm_interop;
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:web/web.dart' as web;

import '../../firebase_options.dart';
import '../constants/app_constants.dart';

/// Scope registered in [web/index.html] — must not be '/' (Flutter owns that).
const String _fcmServiceWorkerScope = '/firebase-cloud-messaging-push-scope';
const String _fcmServiceWorkerScript = '/firebase-messaging-sw.js';

const _fcmRecoverySessionKeys = [
  'wpgg_pending_push_enable',
  'wpgg_fcm_reload_pending',
  'wpgg_fcm_needs_reset',
];

const _firebaseIndexedDbNames = [
  'firebase-messaging-database',
  'firebase-installations-database',
  'firebase-heartbeat-database',
];

/// Clears stale session flags from older recovery flows (no-op if absent).
void clearFcmRecoveryFlags() {
  if (!kIsWeb) {
    return;
  }
  for (final key in _fcmRecoverySessionKeys) {
    web.window.sessionStorage.removeItem(key);
  }
}

void _assertValidVapidKey(String vapidKey) {
  if (vapidKey.isEmpty) {
    throw StateError('WPGG_FIREBASE_VAPID_KEY is missing.');
  }
  if (vapidKey.contains('VAPID') || vapidKey.contains('TU_')) {
    throw StateError(
      'WPGG_FIREBASE_VAPID_KEY parece un placeholder ($vapidKey). '
      'Rebuild con la clave pública real de Firebase Console → Cloud Messaging '
      '→ Web Push certificates.',
    );
  }
  try {
    final normalized = vapidKey.replaceAll('-', '+').replaceAll('_', '/');
    final padding = (4 - normalized.length % 4) % 4;
    final decoded = base64.decode(normalized + '=' * padding);
    if (decoded.length != 65 || decoded.first != 0x04) {
      throw const FormatException('invalid VAPID length or prefix');
    }
  } on FormatException {
    throw StateError(
      'WPGG_FIREBASE_VAPID_KEY no es una clave VAPID válida. '
      'Copiá la clave pública exacta de Firebase Console y rebuild con '
      '--dart-define=WPGG_FIREBASE_VAPID_KEY=...',
    );
  }
}

Future<void> _deleteIndexedDb(String name) {
  final completer = Completer<void>();
  final request = web.window.indexedDB.deleteDatabase(name);
  request.onsuccess = ((web.Event _) {
    if (!completer.isCompleted) completer.complete();
  }).toJS;
  request.onerror = ((web.Event _) {
    if (!completer.isCompleted) completer.complete();
  }).toJS;
  request.onblocked = ((web.Event _) {
    if (!completer.isCompleted) completer.complete();
  }).toJS;
  return completer.future;
}

Future<void> _clearFcmBrowserStorage() async {
  final container = web.window.navigator.serviceWorker;
  final registrations = await container.getRegistrations().toDart;
  for (final reg in registrations.toDart) {
    final sub = await reg.pushManager.getSubscription().toDart;
    if (sub != null) {
      await sub.unsubscribe().toDart;
    }
  }

  for (final name in _firebaseIndexedDbNames) {
    await _deleteIndexedDb(name);
  }

  await Future<void>.delayed(const Duration(milliseconds: 300));
}

/// Initializes Firebase on web. Mobile platforms are configured separately.
Future<void> bootstrapFirebase() async {
  if (!kIsWeb) {
    return;
  }

  clearFcmRecoveryFlags();

  const apiKey = AppConstants.firebaseApiKey;
  if (apiKey.isEmpty) {
    throw StateError(
      'WPGG_FIREBASE_API_KEY is missing. Build/run with '
      '--dart-define=WPGG_FIREBASE_API_KEY=<your-web-api-key>.',
    );
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  setupWebPushForegroundHandler();
  setupWebPushServiceWorkerMessageBridge();
}

void Function()? _webPushForegroundListener;

/// Optional hook to refresh in-app inbox when a push arrives in the foreground.
void setWebPushForegroundListener(void Function()? listener) {
  _webPushForegroundListener = listener;
}

/// Web: with the tab focused, FCM delivers here — not via the service worker.
void setupWebPushForegroundHandler() {
  if (!kIsWeb) {
    return;
  }

  FirebaseMessaging.onMessage.listen((message) {
    debugPrint(
      'FCM foreground: ${message.notification?.title} — ${message.notification?.body}',
    );
    _showBrowserNotification(message);
    _webPushForegroundListener?.call();
  });
}

/// Background pushes are handled in [firebase-messaging-sw.js]; the SW notifies
/// open tabs via postMessage so the in-app inbox can refresh.
void setupWebPushServiceWorkerMessageBridge() {
  if (!kIsWeb) {
    return;
  }

  web.window.navigator.serviceWorker.onmessage =
      ((web.MessageEvent event) {
        debugPrint('FCM service worker message → refresh inbox');
        _webPushForegroundListener?.call();
      }).toJS;
}

void _showBrowserNotification(RemoteMessage message) {
  if (web.Notification.permission != 'granted') {
    return;
  }

  final title = message.notification?.title ?? 'WPGG';
  final body = message.notification?.body ?? '';
  web.Notification(
    title,
    web.NotificationOptions(
      body: body,
      icon: '/icons/Icon-192.png',
    ),
  );
}

Future<String?>? _fetchWebPushTokenInFlight;

/// Returns the FCM registration token for web push, or null if unavailable.
Future<String?> fetchWebPushToken() {
  if (!kIsWeb) {
    return Future<String?>.value(null);
  }
  return _fetchWebPushTokenInFlight ??= _fetchWebPushTokenImpl().whenComplete(() {
    _fetchWebPushTokenInFlight = null;
  });
}

StateError _fcmRegistrationFailedError(FirebaseException e) {
  return StateError(
    'No se pudo registrar push (401). Pasos: 1) Firebase Console → Authentication '
    '→ Authorized domains → agregar wpgg.lol. 2) Cloud Messaging → Web Push '
    'certificates → usar la clave pública del par activo en Vercel '
    '(WPGG_FIREBASE_VAPID_KEY). 3) DevTools → Application → Clear site data, '
    'recargar y volver a activar. (${e.code})',
  );
}

Future<void> _resetFcmWebPushState() async {
  await _clearFcmBrowserStorage();
  try {
    await FirebaseMessaging.instance.deleteToken();
  } catch (_) {}
}

Future<web.ServiceWorkerRegistration> _ensureFcmServiceWorker() async {
  final container = web.window.navigator.serviceWorker;
  await container.ready.toDart;

  final registration = await container
      .register(
        _fcmServiceWorkerScript.toJS,
        web.RegistrationOptions(scope: _fcmServiceWorkerScope),
      )
      .toDart;

  await registration.update().toDart;

  for (var i = 0; i < 30; i++) {
    if (registration.active != null) {
      return registration;
    }
    final existing =
        await container.getRegistration(_fcmServiceWorkerScope).toDart;
    if (existing?.active != null) {
      return existing!;
    }
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }

  throw StateError(
    'firebase-messaging-sw.js no está activo. Clear site data y recargá.',
  );
}

Future<String> _getTokenWithFcmServiceWorker(String vapidKey) async {
  final swRegistration = await _ensureFcmServiceWorker();
  final messaging = fcm_messaging.getMessagingInstance(
    core_interop.app(Firebase.app().name),
  );

  return convertWebExceptions(() async {
    final token = await fcm_interop
        .getToken(
          messaging.jsObject,
          fcm_interop.GetTokenOptions(
            vapidKey: vapidKey.toJS,
            serviceWorkerRegistration: swRegistration,
          ),
        )
        .toDart;
    return token.toDart;
  });
}

Future<String?> _fetchWebPushTokenImpl() async {
  const vapidKey = AppConstants.firebaseVapidKey;
  _assertValidVapidKey(vapidKey);

  clearFcmRecoveryFlags();

  final messaging = FirebaseMessaging.instance;
  final settings = await messaging.requestPermission();
  if (settings.authorizationStatus == AuthorizationStatus.denied) {
    return null;
  }

  try {
    return await _getTokenWithFcmServiceWorker(vapidKey).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        throw StateError(
          'FCM tardó demasiado. Probá DevTools → Application → Clear site data '
          'y recargá la página.',
        );
      },
    );
  } on FirebaseException catch (e) {
    debugPrint('FCM getToken error: ${e.code} — ${e.message}');
    if (e.code == 'token-subscribe-failed') {
      throw _fcmRegistrationFailedError(e);
    }
    rethrow;
  }
}

/// Removes the current FCM token from this browser/device.
Future<void> deleteWebPushToken() async {
  if (!kIsWeb) {
    return;
  }
  await _resetFcmWebPushState();
}

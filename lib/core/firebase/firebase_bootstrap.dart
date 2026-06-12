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

/// Initializes Firebase on web. Mobile platforms are configured separately.
Future<void> bootstrapFirebase() async {
  if (!kIsWeb) {
    return;
  }

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

/// Removes push subscriptions that may have been created with a wrong VAPID key
/// or on the wrong service worker (e.g. flutter_service_worker.js).
Future<void> _clearStalePushSubscriptions() async {
  final container = web.window.navigator.serviceWorker;
  for (final scope in [_fcmServiceWorkerScope, '/']) {
    final reg = await container.getRegistration(scope).toDart;
    if (reg == null) continue;
    final sub = await reg.pushManager.getSubscription().toDart;
    if (sub != null) {
      await sub.unsubscribe().toDart;
    }
  }
  try {
    await FirebaseMessaging.instance.deleteToken();
  } catch (_) {}
}

Future<web.ServiceWorkerRegistration> _waitForFcmServiceWorker() async {
  final container = web.window.navigator.serviceWorker;
  for (var i = 0; i < 30; i++) {
    final reg = await container.getRegistration(_fcmServiceWorkerScope).toDart;
    if (reg?.active != null) {
      return reg!;
    }
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }
  throw StateError(
    'firebase-messaging-sw.js is not active at $_fcmServiceWorkerScope. '
    'Clear site data and reload.',
  );
}

/// Calls Firebase JS getToken with the FCM service worker registration explicitly.
///
/// FlutterFire's [FirebaseMessaging.getToken] without [serviceWorkerScriptPath]
/// may not bind to the isolated FCM scope; passing [serviceWorkerRegistration]
/// fixes the 401 on fcmregistrations when flutter_service_worker.js is present.
Future<String> _getTokenWithFcmServiceWorker(String vapidKey) async {
  final swRegistration = await _waitForFcmServiceWorker();
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

  final messaging = FirebaseMessaging.instance;
  final settings = await messaging.requestPermission();
  if (settings.authorizationStatus == AuthorizationStatus.denied) {
    return null;
  }

  await _clearStalePushSubscriptions();

  try {
    return await _getTokenWithFcmServiceWorker(vapidKey);
  } on FirebaseException catch (e) {
    debugPrint('FCM getToken error: ${e.code} — ${e.message}');
    if (e.code == 'token-subscribe-failed') {
      throw StateError(
        'FCM registration failed: la suscripción push no coincide con la '
        'VAPID key. En Firebase Console → Cloud Messaging → Web Push '
        'certificates, verificá que la clave pública sea exactamente la del '
        'build (WPGG_FIREBASE_VAPID_KEY). Si no coincide, generá un key pair '
        'nuevo, actualizá el build y borrá datos del sitio.',
      );
    }
    rethrow;
  }
}

/// Removes the current FCM token from this browser/device.
Future<void> deleteWebPushToken() async {
  if (!kIsWeb) {
    return;
  }
  await FirebaseMessaging.instance.deleteToken();
}

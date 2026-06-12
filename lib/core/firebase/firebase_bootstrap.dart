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
  if (vapidKey.isEmpty) {
    throw StateError('WPGG_FIREBASE_VAPID_KEY is missing.');
  }

  final messaging = FirebaseMessaging.instance;
  final settings = await messaging.requestPermission();
  if (settings.authorizationStatus == AuthorizationStatus.denied) {
    return null;
  }

  try {
    return await _getTokenWithFcmServiceWorker(vapidKey);
  } on FirebaseException catch (e) {
    debugPrint('FCM getToken error: ${e.code} — ${e.message}');
    if (e.code == 'token-subscribe-failed') {
      throw StateError(
        'FCM registration failed. Clear site data for wpgg.lol and try again.',
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

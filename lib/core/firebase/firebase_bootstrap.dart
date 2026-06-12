import 'dart:js_interop';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:web/web.dart' as web;

import '../../firebase_options.dart';
import '../constants/app_constants.dart';

/// Scope used in [web/index.html] — must not be '/' (Flutter owns that scope).
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

Future<void> _waitForFcmServiceWorker() async {
  final container = web.window.navigator.serviceWorker;
  for (var i = 0; i < 30; i++) {
    final reg = await container.getRegistration(_fcmServiceWorkerScope).toDart;
    if (reg?.active != null) {
      return;
    }
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }
  throw StateError(
    'firebase-messaging-sw.js is not active at $_fcmServiceWorkerScope. '
    'Clear site data and reload.',
  );
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

  await _waitForFcmServiceWorker();

  try {
    // SW registered in index.html; do not pass serviceWorkerScriptPath (scope '/' conflicts with Flutter).
    return await messaging.getToken(vapidKey: vapidKey);
  } on FirebaseException catch (e) {
    debugPrint('FCM getToken error: ${e.code} — ${e.message}');
    if (e.code == 'token-subscribe-failed') {
      throw StateError(
        'FCM registration failed. In DevTools → Application → Service Workers '
        'you should see firebase-messaging-sw.js (scope $_fcmServiceWorkerScope) '
        'next to flutter_service_worker.js. Clear site data and try again.',
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

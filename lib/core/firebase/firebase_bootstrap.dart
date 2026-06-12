import 'dart:js_interop';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:web/web.dart' as web;

import '../../firebase_options.dart';
import '../constants/app_constants.dart';

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
///
/// Requires compile-time defines:
/// - [AppConstants.firebaseApiKey] (`WPGG_FIREBASE_API_KEY`)
/// - [AppConstants.firebaseVapidKey] (Firebase Console → Cloud Messaging → Web Push certificates)
///
/// The FCM service worker is registered in [web/index.html] under scope
/// `/firebase-cloud-messaging-push-scope` (FlutterFire convention).
///
/// Call only after the user grants notification permission (browser requirement).
Future<String?> fetchWebPushToken() {
  if (!kIsWeb) {
    return Future<String?>.value(null);
  }
  return _fetchWebPushTokenInFlight ??= _fetchWebPushTokenImpl().whenComplete(() {
    _fetchWebPushTokenInFlight = null;
  });
}

Future<String?> _fetchWebPushTokenImpl() async {
  const apiKey = AppConstants.firebaseApiKey;
  if (apiKey.isEmpty) {
    throw StateError(
      'WPGG_FIREBASE_API_KEY is missing. Build/run with '
      '--dart-define=WPGG_FIREBASE_API_KEY=<your-web-api-key>.',
    );
  }

  const vapidKey = AppConstants.firebaseVapidKey;
  if (vapidKey.isEmpty) {
    throw StateError(
      'WPGG_FIREBASE_VAPID_KEY is missing. Build/run with '
      '--dart-define=WPGG_FIREBASE_VAPID_KEY=<web-push-vapid-key>.',
    );
  }

  final messaging = FirebaseMessaging.instance;
  final settings = await messaging.requestPermission();
  if (settings.authorizationStatus == AuthorizationStatus.denied) {
    return null;
  }

  // Wait for the FCM SW registered in index.html (not flutter_service_worker.js).
  await web.window.navigator.serviceWorker.ready.toDart;

  try {
    // vapidKey only — SW path/scope is handled by index.html registration.
    return await messaging.getToken(vapidKey: vapidKey);
  } on FirebaseException catch (e) {
    if (e.code == 'token-subscribe-failed') {
      throw StateError(
        'FCM token registration failed. Clear site data for wpgg.lol '
        '(Application → Service Workers → Unregister all, then Clear site data) '
        'and try again. If it persists, check DevTools → Application → '
        'Service Workers: firebase-messaging-sw.js must appear alongside '
        'flutter_service_worker.js.',
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

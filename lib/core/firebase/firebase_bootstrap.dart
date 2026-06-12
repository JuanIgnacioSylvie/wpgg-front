import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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

/// Path to the FCM service worker at the site root (see web/firebase-messaging-sw.js).
const String _fcmServiceWorkerPath = '/firebase-messaging-sw.js';

/// Returns the FCM registration token for web push, or null if unavailable.
///
/// Requires compile-time defines:
/// - [AppConstants.firebaseApiKey] (`WPGG_FIREBASE_API_KEY`)
/// - [AppConstants.firebaseVapidKey] (Firebase Console → Cloud Messaging → Web Push certificates)
///
/// Call only after the user grants notification permission (browser requirement).
Future<String?> fetchWebPushToken() async {
  if (!kIsWeb) {
    return null;
  }

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

  // FCM registrations occasionally returns 401 despite a valid Installations
  // token (firebase-js-sdk#5081). Retry with backoff before surfacing an error.
  const maxAttempts = 5;
  for (var attempt = 1; attempt <= maxAttempts; attempt++) {
    try {
      if (attempt > 1) {
        // Drop stale push subscription / FIS pairing before retrying.
        await messaging.deleteToken();
      }
      return await messaging.getToken(
        vapidKey: vapidKey,
        serviceWorkerScriptPath: _fcmServiceWorkerPath,
      );
    } on FirebaseException catch (e) {
      final isSubscribeFailed = e.code == 'messaging/token-subscribe-failed';
      if (isSubscribeFailed && attempt < maxAttempts) {
        await Future<void>.delayed(Duration(seconds: 2 * attempt));
        continue;
      }
      if (isSubscribeFailed) {
        throw StateError(
          'FCM registration failed after $maxAttempts attempts. '
          'Installations works but registrations returns 401. '
          'In Google Cloud → Credentials → Browser key → API restrictions, '
          'ensure **FCM Registration API** (fcmregistrations.googleapis.com) '
          'is in the list — it is separate from Firebase Cloud Messaging API. '
          'Also enable: https://console.cloud.google.com/apis/library/fcmregistrations.googleapis.com?project=wpgg-7e831',
        );
      }
      rethrow;
    }
  }
  return null;
}

/// Removes the current FCM token from this browser/device.
Future<void> deleteWebPushToken() async {
  if (!kIsWeb) {
    return;
  }
  await FirebaseMessaging.instance.deleteToken();
}

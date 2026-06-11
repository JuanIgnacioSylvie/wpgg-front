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

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

/// Returns the FCM registration token for web push, or null if unavailable.
///
/// Requires [AppConstants.firebaseVapidKey] (Cloud Messaging → Web Push certificates).
/// Call only after the user grants notification permission (browser requirement).
Future<String?> fetchWebPushToken() async {
  if (!kIsWeb) {
    return null;
  }

  const vapidKey = AppConstants.firebaseVapidKey;
  if (vapidKey.isEmpty) {
    return null;
  }

  final messaging = FirebaseMessaging.instance;
  final settings = await messaging.requestPermission();
  if (settings.authorizationStatus == AuthorizationStatus.denied) {
    return null;
  }

  return messaging.getToken(vapidKey: vapidKey);
}

/// Removes the current FCM token from this browser/device.
Future<void> deleteWebPushToken() async {
  if (!kIsWeb) {
    return;
  }
  await FirebaseMessaging.instance.deleteToken();
}

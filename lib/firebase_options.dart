// Firebase config for WPGG (project wpgg-7e831).
// Web app registered in Firebase Console. Android/iOS: run `flutterfire configure`.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        throw UnsupportedError(
          'DefaultFirebaseOptions.android has not been configured. '
          'Run: flutterfire configure --project=wpgg-7e831',
        );
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions.ios has not been configured. '
          'Run: flutterfire configure --project=wpgg-7e831',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAGdATr33G-dPeQfVggKbqkK1RyaGYp1pA',
    appId: '1:966474300066:web:d50c60fc81bac09d80f5fb',
    messagingSenderId: '966474300066',
    projectId: 'wpgg-7e831',
    authDomain: 'wpgg-7e831.firebaseapp.com',
    storageBucket: 'wpgg-7e831.firebasestorage.app',
    measurementId: 'G-7FE09H8SDH',
  );
}

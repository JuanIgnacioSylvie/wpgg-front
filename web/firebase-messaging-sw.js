/* Firebase Cloud Messaging service worker (web push). Must live at /firebase-messaging-sw.js */
importScripts('https://www.gstatic.com/firebasejs/11.6.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/11.6.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: 'AIzaSyAGdATr33G-dPeQfVggKbqkK1RyaGYp1pA',
  authDomain: 'wpgg-7e831.firebaseapp.com',
  projectId: 'wpgg-7e831',
  storageBucket: 'wpgg-7e831.firebasestorage.app',
  messagingSenderId: '966474300066',
  appId: '1:966474300066:web:d50c60fc81bac09d80f5fb',
  measurementId: 'G-7FE09H8SDH',
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  const title = payload.notification?.title ?? 'WPGG';
  const options = {
    body: payload.notification?.body,
    icon: '/icons/Icon-192.png',
    data: payload.data ?? {},
  };
  return self.registration.showNotification(title, options);
});

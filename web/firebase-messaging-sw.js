/* Firebase Cloud Messaging service worker. Requires /firebase-config.js at deploy root. */
importScripts('/firebase-config.js');
importScripts('https://www.gstatic.com/firebasejs/11.6.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/11.6.0/firebase-messaging-compat.js');

firebase.initializeApp(self.firebaseConfig);

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

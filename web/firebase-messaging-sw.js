importScripts("https://www.gstatic.com/firebasejs/10.12.2/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.12.2/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyDLfFHL_erUWqwjKOH6dYiRosG0yP1VEB8",
  authDomain: "ai-career-app-a38db.firebaseapp.com",
  projectId: "ai-career-app-a38db",
  storageBucket: "ai-career-app-a38db.firebasestorage.app",
  messagingSenderId: "108208458576",
  appId: "1:108208458576:web:360e099b84195f25e3ba55",
});

const messaging = firebase.messaging();
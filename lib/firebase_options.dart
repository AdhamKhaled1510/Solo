/// قالب Firebase Options - نظفه بعد تشغيل `flutterfire configure`
/// روح لـ Project Settings > General > Your apps > Add app > Flutter
/// أو استخدم الأمر: flutterfire configure
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android: return android;
      case TargetPlatform.iOS: return ios;
      case TargetPlatform.macOS: return macos;
      case TargetPlatform.windows: return windows;
      case TargetPlatform.linux: return linux;
      default: throw Exception('Unsupported platform');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    authDomain: 'YOUR_PROJECT.firebaseapp.com',
    storageBucket: 'YOUR_PROJECT.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBBMO1ArFX-c_RgAVZIo1XKUDgfQS63WB0',
    appId: '1:625552838603:android:b2b52f153209885fb8b04e',
    messagingSenderId: '625552838603',
    projectId: 'solo-4f84b',
    storageBucket: 'solo-4f84b.firebasestorage.app',
  );
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBZPfB7ztxfPUOwNrDKQNP9HpQT-QFOuyY',
    appId: '1:625552838603:ios:5576d7452beecc8db8b04e',
    messagingSenderId: '625552838603',
    projectId: 'solo-4f84b',
    storageBucket: 'solo-4f84b.firebasestorage.app',
    iosClientId: '625552838603-r77mv0nus28shii3d6bieu2ib9s693o8.apps.googleusercontent.com',
    iosBundleId: 'com.mystudy.mystudyApp',
  );
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBZPfB7ztxfPUOwNrDKQNP9HpQT-QFOuyY',
    appId: '1:625552838603:ios:5576d7452beecc8db8b04e',
    messagingSenderId: '625552838603',
    projectId: 'solo-4f84b',
    storageBucket: 'solo-4f84b.firebasestorage.app',
    iosClientId: '625552838603-r77mv0nus28shii3d6bieu2ib9s693o8.apps.googleusercontent.com',
    iosBundleId: 'com.mystudy.mystudyApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB3HrIikR41mW3qo82XPteosK_pvRd1aiQ',
    appId: '1:625552838603:web:42b7dd0dc5f62a8ab8b04e',
    messagingSenderId: '625552838603',
    projectId: 'solo-4f84b',
    authDomain: 'solo-4f84b.firebaseapp.com',
    storageBucket: 'solo-4f84b.firebasestorage.app',
    measurementId: 'G-KJWZZJZ7VT',
  );
  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'AIzaSyB3HrIikR41mW3qo82XPteosK_pvRd1aiQ',
    appId: '1:625552838603:web:42b7dd0dc5f62a8ab8b04e',
    messagingSenderId: '625552838603',
    projectId: 'solo-4f84b',
    authDomain: 'solo-4f84b.firebaseapp.com',
    storageBucket: 'solo-4f84b.firebasestorage.app',
  );
}

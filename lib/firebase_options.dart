// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA5Gd6WXQwhvgNK3sGNSzMMdWm52hIP0jE',
    appId: '1:286047540866:web:31e2347d302bc5791d869b',
    messagingSenderId: '286047540866',
    projectId: 'sound-of-meme-26b68',
    authDomain: 'sound-of-meme-26b68.firebaseapp.com',
    storageBucket: 'sound-of-meme-26b68.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB4vKZc4N4VNA2d-0GbhGM4oChiIb7wurk',
    appId: '1:286047540866:android:1b93868aaba7013c1d869b',
    messagingSenderId: '286047540866',
    projectId: 'sound-of-meme-26b68',
    storageBucket: 'sound-of-meme-26b68.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD-t0EKr0ThQU7S1E1b-kuSVA1m8Azv3GA',
    appId: '1:286047540866:ios:88a3b7064265a86e1d869b',
    messagingSenderId: '286047540866',
    projectId: 'sound-of-meme-26b68',
    storageBucket: 'sound-of-meme-26b68.appspot.com',
    androidClientId: '286047540866-6aac2ut8g8ophgb8l9jjf5hfjvj4fggh.apps.googleusercontent.com',
    iosClientId: '286047540866-vb3hh17qdjba651ala58l2l15jt4uk87.apps.googleusercontent.com',
    iosBundleId: 'com.example.ventures',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD-t0EKr0ThQU7S1E1b-kuSVA1m8Azv3GA',
    appId: '1:286047540866:ios:88a3b7064265a86e1d869b',
    messagingSenderId: '286047540866',
    projectId: 'sound-of-meme-26b68',
    storageBucket: 'sound-of-meme-26b68.appspot.com',
    androidClientId: '286047540866-6aac2ut8g8ophgb8l9jjf5hfjvj4fggh.apps.googleusercontent.com',
    iosClientId: '286047540866-vb3hh17qdjba651ala58l2l15jt4uk87.apps.googleusercontent.com',
    iosBundleId: 'com.example.ventures',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA5Gd6WXQwhvgNK3sGNSzMMdWm52hIP0jE',
    appId: '1:286047540866:web:3f6ab14cff7cd5f51d869b',
    messagingSenderId: '286047540866',
    projectId: 'sound-of-meme-26b68',
    authDomain: 'sound-of-meme-26b68.firebaseapp.com',
    storageBucket: 'sound-of-meme-26b68.appspot.com',
  );

}
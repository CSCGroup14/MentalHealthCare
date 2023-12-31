// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBkUyY1Va2iXkdaetNglchBjxoy8d-nt-U',
    appId: '1:1051313343633:web:23335d1939165676b8c330',
    messagingSenderId: '1051313343633',
    projectId: 'mentalhealthcare-6acc4',
    authDomain: 'mentalhealthcare-6acc4.firebaseapp.com',
    storageBucket: 'mentalhealthcare-6acc4.appspot.com',
    measurementId: 'G-QY9RKV0N5K',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDs8-XMQa2pxtzPnnX6eiePRhVFy1_SqAg',
    appId: '1:1051313343633:android:e295305b45395000b8c330',
    messagingSenderId: '1051313343633',
    projectId: 'mentalhealthcare-6acc4',
    storageBucket: 'mentalhealthcare-6acc4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBf0_ksFWSMsMbjXB6-BUn37z_m5H5F77E',
    appId: '1:1051313343633:ios:6c72ae28106ae7bcb8c330',
    messagingSenderId: '1051313343633',
    projectId: 'mentalhealthcare-6acc4',
    storageBucket: 'mentalhealthcare-6acc4.appspot.com',
    iosClientId: '1051313343633-b3akib7r0otug2t5vp763fpq7s19q8mh.apps.googleusercontent.com',
    iosBundleId: 'com.example.mentalhealthcare',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBf0_ksFWSMsMbjXB6-BUn37z_m5H5F77E',
    appId: '1:1051313343633:ios:6c72ae28106ae7bcb8c330',
    messagingSenderId: '1051313343633',
    projectId: 'mentalhealthcare-6acc4',
    storageBucket: 'mentalhealthcare-6acc4.appspot.com',
    iosClientId: '1051313343633-b3akib7r0otug2t5vp763fpq7s19q8mh.apps.googleusercontent.com',
    iosBundleId: 'com.example.mentalhealthcare',
  );
}

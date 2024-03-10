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
    apiKey: 'AIzaSyDOiEjm27ji5ZSt5Wc2GwIHkIsA1jkNWTk',
    appId: '1:945002006532:web:c094d58908ce0e664b8d51',
    messagingSenderId: '945002006532',
    projectId: 'mechanicfinder-506f4',
    authDomain: 'mechanicfinder-506f4.firebaseapp.com',
    storageBucket: 'mechanicfinder-506f4.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBvnI_HT5yu35fnpHSc_Gr6z24QDKpajaA',
    appId: '1:945002006532:android:b3948b2af9ba86ae4b8d51',
    messagingSenderId: '945002006532',
    projectId: 'mechanicfinder-506f4',
    storageBucket: 'mechanicfinder-506f4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDhf_t8jV_gedw7iTA-6T-EwdeCkabsq0s',
    appId: '1:945002006532:ios:cc4ffb8e444dad3a4b8d51',
    messagingSenderId: '945002006532',
    projectId: 'mechanicfinder-506f4',
    storageBucket: 'mechanicfinder-506f4.appspot.com',
    androidClientId: '945002006532-b2fagpfl7vmddpliagvld7cb2lr7b2ma.apps.googleusercontent.com',
    iosClientId: '945002006532-kq6be5e47hs6sea6u3vedkqmijq0nkog.apps.googleusercontent.com',
    iosBundleId: 'com.example.forveel',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDhf_t8jV_gedw7iTA-6T-EwdeCkabsq0s',
    appId: '1:945002006532:ios:cc4ffb8e444dad3a4b8d51',
    messagingSenderId: '945002006532',
    projectId: 'mechanicfinder-506f4',
    storageBucket: 'mechanicfinder-506f4.appspot.com',
    androidClientId: '945002006532-b2fagpfl7vmddpliagvld7cb2lr7b2ma.apps.googleusercontent.com',
    iosClientId: '945002006532-kq6be5e47hs6sea6u3vedkqmijq0nkog.apps.googleusercontent.com',
    iosBundleId: 'com.example.forveel',
  );
}
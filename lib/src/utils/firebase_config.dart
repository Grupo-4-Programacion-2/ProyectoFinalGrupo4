import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class FirebaseConfig {
  static FirebaseOptions get currentPlatform {
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
    // TODO(Lyokone): Remove when FlutterFire CLI updated
      case TargetPlatform.windows:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC5RmZ1Jiq0mtr1jq_sTUaMWThvMKBdDmU',
    appId: '1:70886265594:android:e659d8fda8d3b0e96def43',
    messagingSenderId: '70886265594',
    projectId: 'proyectofinal-76b59',
    databaseURL: 'https://react-native-firebase-testing.firebaseio.com',
    storageBucket: 'proyectofinal-76b59.appspot.com',
  );

}
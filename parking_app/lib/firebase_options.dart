import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return FirebaseOptions(
        apiKey: 'AIzaSyDY-DvK-3B7YKE01Fp2cBq6Bbh_BqRFJk0',
        authDomain: 'parkingapp-773fb.firebaseapp.com',
        projectId: 'parkingapp-773fb',
        storageBucket: 'parkingapp-773fb.appspot.com',
        messagingSenderId: '168612567317',
        appId: '1:168612567317:web:aec8aa6d32c2033e89311c',
      );
    } else {
      return FirebaseOptions(
        apiKey: 'AIzaSyDY-DvK-3B7YKE01Fp2cBq6Bbh_BqRFJk0',
        appId: '1:168612567317:android:aec8aa6d32c2033e89311c',
        messagingSenderId: '168612567317',
        projectId: 'parkingapp-773fb',
        storageBucket: 'parkingapp-773fb.appspot.com',
      );
    }
  }
}

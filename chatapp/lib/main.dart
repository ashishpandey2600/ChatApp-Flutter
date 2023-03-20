import 'package:chatapp/shared/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDny6AIjtCZAfdLWMkZSgApkFe0jGOffTQ",
            authDomain: Constants.authDomain,
            projectId: Constants.projectId,
            storageBucket: Constants.storageBucket,
            messagingSenderId: Constants.messagingSenderId,
            appId: Constants.appId,
            measurementId: Constants.measurementId));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
    );
  }
}

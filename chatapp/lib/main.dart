import 'package:chatapp/helper/helper_funtion.dart';
import 'package:chatapp/pages/homepage.dart';
import 'package:chatapp/shared/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'pages/auth/login_page.dart';

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
  bool _isSignedIn = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await HelperFuntion.getUserLoggedInStatus().then((value) {
      if (value != null) {
        _isSignedIn = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Constants().primaryColor,
      scaffoldBackgroundColor: Colors.white),
     
      home: _isSignedIn ?const HomePage():const LogIn(),
    );
  }
}

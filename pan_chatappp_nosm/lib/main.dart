import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pan_chatappp_nosm/pages/completeprofile.dart';
import 'package:pan_chatappp_nosm/pages/homepage.dart';
import 'package:pan_chatappp_nosm/pages/loginpage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/usermodel.dart';

class HomePage extends StatefulWidget {
    final UserModel? userModel;
  final User? firebaseuser;
  const HomePage({super.key,required this.firebaseuser,required this.userModel});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

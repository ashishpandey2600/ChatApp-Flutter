import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pan_chatappp_nosm/models/usermodel.dart';
import 'package:pan_chatappp_nosm/pages/homepage.dart';
import 'package:pan_chatappp_nosm/pages/signuppage.dart';

import '../models/uihelper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(children: [
                Text(
                  "Chat App",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: "Email Address"),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    labelText: "Password",
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                CupertinoButton(
                  child: Text("Login"),
                  onPressed: () {
                    checkValues();
                  },
                  color: Theme.of(context).colorScheme.secondary,
                )
              ]),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an account?",
            style: TextStyle(fontSize: 16),
          ),
          CupertinoButton(
            child: const Text("Sign Up", style: TextStyle(fontSize: 16)),
            onPressed: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => SignupPage()));
            },
          )
        ],
      )),
    );
  }

  void checkValues() {
    String email = emailController.text.trim(); //removes space at the end
    String password = passwordController.text.trim();

    if (email == "" || password == "") {
      print("please fill all the field");
    } else {
      login(email, password);
    }
  }

  void login(String email, String password) async {
    UserCredential? credential;
    UiHelper.showLoadingdialog(context, "Logging In..");
    try {
      credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      // Close the loading Dialog

      Navigator.pop(context);

      UiHelper.showAlerDialog(
          context, "An error Occured", e.message.toString());
      print(e.message.toString());
    }
    if (credential != null) {
      String uid = credential.user!.uid;

      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      Map<String, dynamic> map = userData.data() as Map<String, dynamic>;
      UserModel userModel = UserModel.fromMap(map);

      Navigator.popUntil(context, (route) => route.isFirst);
      //Go to HomePage
      Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
              builder: (context) => HomePage(
                  firebaseuser: credential!.user!, userModel: userModel)));
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pan_chatappp_nosm/models/uihelper.dart';
import 'package:pan_chatappp_nosm/models/usermodel.dart';
import 'package:pan_chatappp_nosm/pages/completeprofile.dart';

import 'loginpage.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

  //function to check
  void checkValues() {
    String email = emailController.text.trim(); //removes space at the end
    String password = passwordController.text.trim();
    String cnfpassword = confirmpasswordController.text.trim();
    if (email == "" || password == "" || cnfpassword == "") {
      UiHelper.showAlerDialog(
          context, "Incomplete Data", "Please fill all the fields");
    } else if (password != cnfpassword) {
      UiHelper.showAlerDialog(context, "Password Mismatch",
          "The passwords you entered do not match!");
    } else {
      signup(email, password);
    }
  }

  void signup(String email, String password) async {
    UserCredential? credential;
    UiHelper.showLoadingdialog(context, "Creating new account..");
    try {
      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); //Stops the loading dialog

      UiHelper.showAlerDialog(
          context, "An error occured", e.message.toString());
    }
    if (credential != null) {
      String uid = credential.user!.uid;
      UserModel newUser =
          UserModel(uid: uid, email: email, fullname: "", profilepic: "");
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(newUser.toMap())
          .then((value) {
        print("New user created");
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(context,
            CupertinoPageRoute(builder: (context) {
          return CompleteProfile(
              userModel: newUser, firebaseuser: credential!.user!);
        }));
      });
      //data leta hai ek map
    }
  }

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
                  height: 10,
                ),
                TextField(
                  controller: confirmpasswordController,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                CupertinoButton(
                  child: Text("Sign Up"),
                  onPressed: () {
                    checkValues();
                    // Navigator.push(
                    //     context,
                    //     CupertinoPageRoute(
                    //         builder: (context) => CompleteProfile()));
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
            "Already have an account?",
            style: TextStyle(fontSize: 16),
          ),
          CupertinoButton(
            child: const Text("login Up", style: TextStyle(fontSize: 16)),
            onPressed: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => LoginPage()));
            },
          )
        ],
      )),
    );
  }
}

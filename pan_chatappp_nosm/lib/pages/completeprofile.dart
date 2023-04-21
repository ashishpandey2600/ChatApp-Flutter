import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pan_chatappp_nosm/models/uihelper.dart';
import 'package:pan_chatappp_nosm/models/usermodel.dart';
import 'package:pan_chatappp_nosm/pages/homepage.dart';

class CompleteProfile extends StatefulWidget {
  final UserModel userModel;
  final User firebaseuser;
  const CompleteProfile(
      {super.key, required this.userModel, required this.firebaseuser});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  File? imageFile;
  TextEditingController fullNameController = TextEditingController();

  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      cropImage(pickedFile);
    }
  }

  void cropImage(XFile file) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 20);

    if (croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage
            .path); 
      });
    }
  }

  void showPhotoOptions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Upload Profile Picture"),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.gallery);
                },
                leading: Icon(Icons.photo_album),
                title: Text("Select from Gallery"),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.camera);
                },
                leading: Icon(Icons.camera_alt),
                title: Text("Take a Photo"),
              ),
            ]),
          );
        });
  }

  void checkvalues() {
    String fullname = fullNameController.text.trim();
    if (fullname == "" || imageFile == null) {
      UiHelper.showAlerDialog(context, "Incomplete Data ",
          "please fill all the fields and upload a profile picture");
    } else {
      uploadData();
    }
  }

  void uploadData() async {
    // Reference ref = FirebaseStorage.instance
    //     .ref()
    //     .child('profilepic')
    //     .child(widget.userModel!.uid.toString());
    // UploadTask uploadTask = ref.putFile(imageFile!);
    // final snapshot = await uploadTask.whenComplete(() => null);

    UiHelper.showLoadingdialog(context, "Uploading image..");

    UploadTask uploadTask = FirebaseStorage.instance
        .ref("profilepic")
        .child(widget.userModel.uid.toString())
        .putFile(imageFile!);

    // final storageRef = FirebaseStorage.instance.ref();
    // final mountainsRef = storageRef.child("mountains.jpg");
    // final mountainImagesRef = storageRef.child("profilepic/mountains.jpg");

    // final uploadTask =
    //     storageRef.child("profilepic/mountains.jpg").putFile(imageFile!);
    TaskSnapshot snapshot = await uploadTask;
    String? imageUrl = await snapshot.ref.getDownloadURL();
    String? fullname = fullNameController.text.trim();

    widget.userModel.fullname = fullname;
    widget.userModel.profilepic = imageUrl;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel.uid)
        .set(widget.userModel.toMap())
        .then((value) {
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
              builder: (context) => HomePage(
                  firebaseuser: widget.firebaseuser,
                  userModel: widget.userModel)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("Complete Profile"),
      ),
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            CupertinoButton(
              onPressed: () {
                showPhotoOptions();
              },
              padding: EdgeInsets.all(0),
              child: CircleAvatar(
                radius: 60,
                backgroundImage:
                    (imageFile != null) ? FileImage(imageFile!) : null,
                child: (imageFile == null)
                    ? Icon(
                        Icons.person,
                        size: 60,
                      )
                    : null,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: fullNameController,
              decoration: InputDecoration(labelText: "Full Name"),
            ),
            CupertinoButton(
              child: const Text("Submit", style: TextStyle(fontSize: 16)),
              color: Theme.of(context).colorScheme.secondary,
              onPressed: () {
                checkvalues();
              },
            ),
          ],
        ),
      )),
    );
  }
}

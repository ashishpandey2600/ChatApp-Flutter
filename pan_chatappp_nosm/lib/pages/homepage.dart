import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pan_chatappp_nosm/models/chatroommodel.dart';
import 'package:pan_chatappp_nosm/models/firebasehelper.dart';
import 'package:pan_chatappp_nosm/models/uihelper.dart';
import 'package:pan_chatappp_nosm/pages/chatroompage.dart';
import 'package:pan_chatappp_nosm/pages/loginpage.dart';
import 'package:pan_chatappp_nosm/pages/searchpage.dart';

import '../models/usermodel.dart';

class HomePage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseuser;
  const HomePage(
      {super.key, required this.firebaseuser, required this.userModel});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Chat App",
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushReplacement(context,
                    CupertinoPageRoute(builder: (context) => LoginPage()));
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: SafeArea(
          child: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("chatroom")
              .where("users", arrayContains: widget.userModel.uid)
              .orderBy("datetime")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                QuerySnapshot chatroomSnapshot = snapshot.data as QuerySnapshot;
                return ListView.builder(
                    itemCount: chatroomSnapshot.docs.length,
                    itemBuilder: (context, index) {
                      ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                          chatroomSnapshot.docs[index].data()
                              as Map<String, dynamic>);

                      Map<String, dynamic> participants =
                          chatRoomModel.participants!;
                      List<String> participantsKeys =
                          participants.keys.toList();
                      //remove are our id

                      participants.remove(widget.userModel.uid);
                      return FutureBuilder(
                        future: FirebaseHelper.getUserModelById(
                            participantsKeys[0]),
                        builder: (context, userData) {
                          if (userData.connectionState ==
                              ConnectionState.done) {
                            if (userData.data != null) {
                              UserModel targetUser = userData.data as UserModel;
                              return ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => ChatRoomPage(
                                              targetUser: targetUser,
                                              chatroom: chatRoomModel,
                                              userModel: widget.userModel,
                                              firebaseUser:
                                                  widget.firebaseuser)));
                                },
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      targetUser.profilepic.toString()),
                                ),
                                title: Text(targetUser.fullname.toString()),
                                subtitle: (chatRoomModel.lastMessage
                                            .toString() !=
                                        "")
                                    ? Text(chatRoomModel.lastMessage.toString())
                                    : Text(
                                        "Say hii to your new friend!",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                      ),
                              );
                            } else {
                              return Container();
                            }
                          } else {
                            return Container();
                          }
                        },
                      );
                    });
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else {
                return Center(
                  child: Text("snapshot"),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => SearchPage(
                      userModel: widget.userModel,
                      firebaseUser: widget.firebaseuser)));
        },
        child: Icon(Icons.search),
      ),
    );
  }
}

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pan_chatappp_nosm/models/chatroommodel.dart';
import 'package:pan_chatappp_nosm/models/usermodel.dart';
import 'package:pan_chatappp_nosm/pages/chatroompage.dart';

import '../main.dart';

class SearchPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const SearchPage(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();

  //Chatroom model which gives present user whom u r taking to
  Future<ChatRoomModel?> getChatroomModel(UserModel targetUser) async {
    ChatRoomModel? chatRoom;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatroom")
        .where("participants.${widget.userModel.uid}", isEqualTo: true)
        .where("participants.${targetUser.uid}", isEqualTo: true)
        .get();

    if (snapshot.docs.length > 0) {
      //Fetch the exiting one

      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatroom =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);

      chatRoom = existingChatroom;
    } else {
      //create a new one
      ChatRoomModel newChatRoom = ChatRoomModel(
        chatroomid: uuid.v1(),
        lastMessage: "",
        participants: {
          widget.userModel.uid.toString(): true,
          targetUser.uid.toString(): true, //to block one user jst false
        },
        users: [widget.userModel.uid.toString(), targetUser.uid.toString()],
        datetime: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection("chatroom")
          .doc(newChatRoom.chatroomid)
          .set(newChatRoom.toMap());

      log("New Chatroom created");
      chatRoom = newChatRoom;
    }
    return chatRoom;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search")),
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(children: [
          TextField(
            controller: searchController,
            decoration: InputDecoration(labelText: "Email Address"),
          ),
          SizedBox(
            height: 20,
          ),
          CupertinoButton(
              color: Theme.of(context).colorScheme.secondary,
              child: Text("Search"),
              onPressed: () {
                setState(() {});
              }),
          SizedBox(
            height: 20,
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .where("email", isEqualTo: searchController.text)
                .where("email", isNotEqualTo: widget.userModel.email)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  QuerySnapshot datasnapshot = snapshot.data as QuerySnapshot;
                  if (datasnapshot.docs.length > 0) {
                    Map<String, dynamic> userMap =
                        datasnapshot.docs[0].data() as Map<String, dynamic>;

                    UserModel searchedUser = UserModel.fromMap(userMap);

                    return ListTile(
                      onTap: () async {
                        ChatRoomModel? chatRoomModel =
                            await getChatroomModel(searchedUser);

                        if (chatRoomModel != null) {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => ChatRoomPage(
                                      targetUser: searchedUser,
                                      chatroom: chatRoomModel,
                                      userModel: widget.userModel,
                                      firebaseUser: widget.firebaseUser)));
                        }
                      },
                      leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(searchedUser.profilepic!)),
                      title: Text(searchedUser.fullname!),
                      subtitle: Text(searchedUser.email!),
                      trailing: Icon(Icons.keyboard_arrow_right),
                    );
                  } else {
                    return Text("NO result found");
                  }
                } else if (snapshot.hasError) {
                  return Text("An error occured");
                } else {
                  return Text("NO result found");
                }
              } else {
                return CircularProgressIndicator();
              }
            },
          )
        ]),
      )),
    );
  }
}

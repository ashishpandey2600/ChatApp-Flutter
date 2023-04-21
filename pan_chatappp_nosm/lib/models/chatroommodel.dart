import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  String? chatroomid;
  Map<String, dynamic>? participants;
  String? lastMessage; //is chat room ke andar last message kon sa tha
  DateTime? datetime;
  List<dynamic>? users;

  ChatRoomModel(
      {this.chatroomid,
      this.participants,
      this.lastMessage,
      this.datetime,
      this.users});

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatroomid = map["chatroomid"];
    participants = map["participants"];
    lastMessage = map["lastmessage"];
    users = map["users"];
    datetime = map["datetime"].toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      "chatroomid": chatroomid,
      "participants": participants,
      "lastmessage": lastMessage,
      "datetime": datetime,
      "users": users,
    };
  }
}

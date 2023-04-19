class UserModel {
  String? uid;
  String? fullname;
  String? email;
  String? profilepic;
//? null bhi ho sakte hai
  UserModel({this.uid, this.fullname, this.email, this.profilepic});

  //firebase mai data store krne ke liye - json serialization
  //object se map
  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map['uid'];
    fullname = map["fullname"];
    email = map["email"];
    profilepic = map["profilepic"];
  }

  //map se object

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "fullname": fullname,
      "email": email,
      "profilepic": profilepic
    };
  }
}

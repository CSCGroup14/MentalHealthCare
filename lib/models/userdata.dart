import "package:cloud_firestore/cloud_firestore.dart";

class Userdata {
  final String? id;
  final String? profilepic;
  final String? username;
  const Userdata({this.profilepic, this.username, this.id});
  // toJson() {
  //   return {"Profilepic": profilepic, "Username": username};
  // }

  factory Userdata.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data()!;
    return Userdata(
        id: document.id,
        profilepic: data["profile_pic"],
        username: data["username"]);
  }
}

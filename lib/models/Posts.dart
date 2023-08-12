// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';

class Post {
  String ownerID;
  String? comment;
  Timestamp timestamp;
  String? username;
  String? profileimage;
  String? postImage;
  String postid;

  Post({
    required this.ownerID,
    required this.comment,
    required this.timestamp,
    required this.username,
    required this.profileimage,
    required this.postImage,
    this.postid = "",
  });

  Map<String, dynamic> toMap() {
    return {
      'ownerID': ownerID,
      'comment': comment,
      'timestamp': timestamp,
      'username': username,
      'profileimage': profileimage,
      'postImage': postImage,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map,String id) {
    return Post(
        ownerID: map['ownerID'] ?? '',
        comment: map['comment'] ?? '',
        timestamp: map['timestamp'] ?? Timestamp.now(),
        username: map['username'],
        profileimage: map['profileimage'],
        postImage: map['postImage'],
         postid:id);
       
  }
}

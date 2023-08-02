// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';

class Post {
  String ownerID;
  String comment;
  Timestamp timestamp;
  String? username;

  Post({
    required this.ownerID,
    required this.comment,
    required this.timestamp,
    required this.username,
  });

  Map<String, dynamic> toMap() {
    return {
      'ownerID': ownerID,
      'comment': comment,
      'timestamp': timestamp,
      'username': username,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      ownerID: map['ownerID'] ?? '',
      comment: map['comment'] ?? '',
      timestamp: map['timestamp'] ?? Timestamp.now(),
      username: map['username'],
    );
  }
}

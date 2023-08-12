// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';

class Comments {
  String? comment;
  Timestamp timestamp;
  String? commenterUsername;
  String? commenterprofileimage;

  Comments({
    required this.comment,
    required this.timestamp,
    required this.commenterUsername,
    required this.commenterprofileimage,
  });

  Map<String, dynamic> toMap() {
    return {
      'comment': comment,
      'timestamp': timestamp,
      'commenterUsername': commenterUsername,
      'commenterprofileimage': commenterprofileimage,
    };
  }

  factory Comments.fromMap(Map<String, dynamic> map) {
    return Comments(
      comment: map['comment'] ?? '',
      timestamp: map['timestamp'] ?? Timestamp.now(),
      commenterUsername: map['commenterUsername'],
      commenterprofileimage: map['commenterprofileimage'] ?? "",
    );
  }
}

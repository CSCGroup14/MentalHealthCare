// ignore: file_names
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  final CollectionReference<Map<String, dynamic>> usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<String> uploadImage(File image) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('profile_pics')
        .child('${DateTime.now()}.png');
    final uploadTask = ref.putFile(image);
    await uploadTask.whenComplete(() {});
    return await ref.getDownloadURL();
  }

  Future<void> saveComment(String comment) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await usersCollection
          .doc(currentUser.uid)
          .collection('comments')
          .add({'comment': comment, 'timestamp': FieldValue.serverTimestamp()});
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserDataStream() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return usersCollection.doc(currentUser.uid).snapshots();
    }
    return const Stream.empty();
  }
}

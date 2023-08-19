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

  Future<String> getUsernameForOwnerID(String ownerid) async {
    try {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(ownerid)
          .get();

      if (userSnapshot.exists) {
        return userSnapshot.data()!['username'];
      }

      return ''; // Return an empty string if the user does not exist
    } catch (e) {
      print('Error fetching username: $e');
      return ''; // Return an empty string in case of an error
    }
  }





  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserDataStream() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return usersCollection.doc(currentUser.uid).snapshots();
    }
    return const Stream.empty();
  }

Future<String> getUserProfileImageURL(String ownerid) async {
    try {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(ownerid)
          .get();
      if (userSnapshot.exists) {
        return userSnapshot.data()!['profile_pic'];
      }
      return ''; // Return an empty string if the user or profileImageURL does not exist
    } catch (e) {
      print('Error fetching user profile image URL: $e');
      return ''; // Return an empty string in case of an error
    }
  }




  
}

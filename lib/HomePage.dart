// ignore_for_file: file_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'firebaseService.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final db = FirebaseFirestore.instance;
  final docRef = db.collection("users");
  File? _image;
  final _imagePicker = ImagePicker();
  final _commentController = TextEditingController();
  final _firebaseService = FirebaseService();

  void _getImage() async {
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  void _saveComment() {
    final String comment = _commentController.text;
    if (comment.isNotEmpty) {
      _firebaseService.saveComment(comment);
      _commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mental Peer Community '),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firebaseService.getUserDataStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final userData = snapshot.data!;
          final profilePic =
              userData['profile_pic'] ?? ''; // URL of the profile pic
          final username = userData['username'] ?? ''; // Username
          final comments = userData['comments'] ?? []; // List of comments

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: profilePic.isEmpty
                      ? const AssetImage('assets/profilepicicon.jpg')
                      : NetworkImage(profilePic) as ImageProvider,
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Username: $username',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: const InputDecoration(
                          hintText: 'Write a comment...',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _getImage,
                      icon: const Icon(Icons.image),
                    ),
                    IconButton(
                      onPressed: _saveComment,
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final commentData = comments[index];
                      final comment = commentData['comment'];
                      final commenterProfilePic = commentData['profile_pic'];
                      final commenterUsername = commentData['username'];
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundImage: commenterProfilePic.isEmpty
                              ? const AssetImage('assets/profilepicicon.jpg')
                              : NetworkImage(commenterProfilePic)
                                  as ImageProvider,
                          child: Text(commenterUsername),
                        ),
                        title: Text(comment),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

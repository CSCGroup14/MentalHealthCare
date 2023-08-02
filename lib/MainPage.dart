// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'models/Posts.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // final Stream<QuerySnapshot> _usersStream =
  //     FirebaseFirestore.instance.collection('users').snapshots();
  // final CollectionReference<Map<String, dynamic>> usersCollection =
  //     FirebaseFirestore.instance.collection('users');

  File? _image;
  final _imagePicker = ImagePicker();
  final TextEditingController _commentController = TextEditingController();
  final CollectionReference<Map<String, dynamic>> postsCollection =
      FirebaseFirestore.instance.collection('posts');

  //Image Picker
  void _getImage() async {
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> savePost() async {
    final String comment = _commentController.text;
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final String username = await getUsernameForOwnerID();

      final post = Post(
        ownerID: currentUser.uid,
        comment: comment,
        timestamp: Timestamp.now(),
        username: username,
      );

      await postsCollection.add(post.toMap());
      _commentController.clear();
    }
  }

  Future<List<Post>> fetchPosts() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await postsCollection.orderBy('timestamp', descending: true).get();

      return querySnapshot.docs.map((doc) => Post.fromMap(doc.data())).toList();
    } catch (e) {
      print("Error fetching posts: $e");
      return [];
    }
  }

  Future<String> getUsernameForOwnerID() async {
    try {
      final userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc().get();

      if (userSnapshot.exists) {
        return userSnapshot.data()!['username'];
      }

      return ''; // Return an empty string if the user does not exist
    } catch (e) {
      print('Error fetching username: $e');
      return ''; // Return an empty string in case of an error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("MainPage"),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(22.0),
            child: Row(
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
                  onPressed: savePost,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ),
        body: FutureBuilder<List<Post>>(
          future: fetchPosts(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final List<Post>? posts = snapshot.data;

            if (posts == null || posts.isEmpty) {
              return const Text('No posts available');
            }
            return Column(children: [
              Expanded(
                  child: Card(
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];

                    return ListTile(
                      title: Text(post.comment),
                      subtitle: Text(
                          'Posted by: ${post.username}'), // Display the username
                    );
                  },
                ),
              )),
            ]);
          },
        ));
  }
}

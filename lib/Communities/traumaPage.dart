// ignore_for_file: avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentalhealthcare/firebaseService.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'dart:io';
import '../Widgets/PostScreen.dart';
import '../models/Posts.dart';



class TraumaPage extends StatefulWidget {
  const TraumaPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TraumaPageState createState() => _TraumaPageState();
}

class _TraumaPageState  extends State<TraumaPage> {
  File? _image;
  final _imagePicker = ImagePicker();
  final TextEditingController _commentController = TextEditingController();
  final CollectionReference<Map<String, dynamic>> postsCollection3 =
      FirebaseFirestore.instance.collection('trauma posts');

  bool hasOffensiveContent(String text) {
    final filter = ProfanityFilter();
    return filter.hasProfanity(text);
  }

  bool hasViolenceWords(String text) {
    final filter = ProfanityFilter();
    final filteredWords = filter.getAllProfanity(text);
    // You can customize how you handle the filtered words if needed
    return filteredWords.isNotEmpty;
  }

  //Image Picker
  Future<String?> getImage() async {
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('post_images')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = storageRef.putFile(_image!);
      final TaskSnapshot uploadSnapshot = await uploadTask.whenComplete(() {});
      final String postimage = await uploadSnapshot.ref.getDownloadURL();
      final User? currentUser = FirebaseAuth.instance.currentUser;

      final String comment = _commentController.text;
      final String username =
          await FirebaseService().getUsernameForOwnerID(currentUser!.uid);
      final String profileimage =
          await FirebaseService().getUserProfileImageURL(currentUser.uid);

      // Upload the image to Firebase Storage and get the image URL

      Post post = Post(
        ownerID: currentUser.uid,
        comment: comment,
        timestamp: Timestamp.now(),
        username: username,
        profileimage: profileimage,
        postImage: postimage,
      );

      await postsCollection3.add(post.toMap());
      _commentController.clear();
    }
    return null;
  }

  Future<void> savePost() async {
    final String comment = _commentController.text;
    // ignore: no_leading_underscores_for_local_identifiers
    final _currentUser = FirebaseAuth.instance.currentUser;
    if (_currentUser != null) {
      final String username =
          await FirebaseService().getUsernameForOwnerID(_currentUser.uid);
      final String profileimage =
          await FirebaseService().getUserProfileImageURL(_currentUser.uid);

      if (hasOffensiveContent(comment) || hasViolenceWords(comment)) {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Offensive or Violence Content Detected'),
              content: const Text(
                  'The comment contains offensive content and cannot be posted.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        return; // Prevent the comment from being posted
      } else {
        Post post = Post(
          ownerID: _currentUser.uid,
          comment: comment,
          timestamp: Timestamp.now(),
          username: username,
          profileimage: profileimage,
          // postImage: postImage,
        );

        await postsCollection3.add(post.toMap());
        _commentController.clear();
      }
    }
  }

  Stream<List<Post>> fetchPostsStream() {
    return postsCollection3
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => Post.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(225, 247, 248, 248),
      appBar: AppBar(
        title: const Text("Trauma Community"),
      ),
      body: Column(
        children: [
          Container(
                      margin: const EdgeInsets.all(3.0),
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: const Color.fromARGB(6, 10, 10, 10),
                          width: 5.0,
                        ),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _commentController,
                              decoration: const InputDecoration(
                                hintText: 'What is on your mind...',
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: getImage,
                            icon: const Icon(Icons.image),
                          ),
                          IconButton(
                            onPressed: () {
                              savePost();
                            },
                            icon: const Icon(Icons.send),
                          ),
                        ],
                      ),
                    ),

        Flexible(
            child: StreamBuilder<List<Post>>(
              stream: fetchPostsStream(),
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
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ignore: avoid_unnecessary_containers
          
                    
                    PostScreen(posts: posts),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

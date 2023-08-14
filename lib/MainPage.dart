// ignore_for_file: avoid_print
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentalhealthcare/post_detail.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'dart:io';
import 'models/Posts.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  File? _image;
  final _imagePicker = ImagePicker();
  final TextEditingController _commentController = TextEditingController();
  final CollectionReference<Map<String, dynamic>> postsCollection =
      FirebaseFirestore.instance.collection('posts');

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
      final String username = await _getUsernameForOwnerID(currentUser!.uid);
      final String profileimage =
          await _getUserProfileImageURL(currentUser.uid);
      

      // Upload the image to Firebase Storage and get the image URL

      Post post = Post(
        ownerID: currentUser.uid,
        comment: comment,
        timestamp: Timestamp.now(),
        username: username,
        profileimage: profileimage,
        postImage: postimage,
      );

      await postsCollection.add(post.toMap());
      _commentController.clear();
    

      
    }
    return null;
  }

  Future<void> savePost() async {
    final String comment = _commentController.text;
    // ignore: no_leading_underscores_for_local_identifiers
    final _currentUser = FirebaseAuth.instance.currentUser;
    if (_currentUser != null) {
      final String username = await _getUsernameForOwnerID(_currentUser.uid);
      final String profileimage =
          await _getUserProfileImageURL(_currentUser.uid);
      // const String? postImage ;

      // Upload the image to Firebase Storage and get the image URL
      if (hasOffensiveContent(comment) || hasViolenceWords(comment)) {
        // Show an alert dialog to inform the user about offensive comment
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Offensive or Violence Content Detected'),
              content: const Text('The comment contains offensive content and cannot be posted.'),
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
      }else {
        Post post = Post(
        ownerID: _currentUser.uid,
        comment: comment,
        timestamp: Timestamp.now(),
        username: username,
        profileimage: profileimage,
        // postImage: postImage,
      );

      await postsCollection.add(post.toMap());
      _commentController.clear();
    }
      }

      
  }

  
Stream<List<Post>> fetchPostsStream() {
  return postsCollection
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((querySnapshot) {
    return querySnapshot.docs.map((doc) => Post.fromMap(doc.data(),doc.id)).toList();
  });
}

  Future<String> _getUsernameForOwnerID(String ownerid) async {
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

  Future<String> _getUserProfileImageURL(String ownerid) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(225, 247, 248, 248),
      appBar: AppBar(
        title: const Text("MainPage"),
      ),
      body: StreamBuilder<List<Post>>(
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
              
              Container(
                margin:const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(10.0),
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
                      onPressed: savePost,
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Card(
                  elevation: 30.0,
                  child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return Container(
                        width: 200.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: const Color.fromARGB(6, 0, 0, 0),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: post.profileimage != null
                                      ? NetworkImage(post.profileimage!)
                                          as ImageProvider
                                      : const AssetImage(
                                          'assets/profilepicicon.jpg',
                                        ),
                                  radius: 20.0,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      '${post.username}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      DateFormat('MMM d')
                                          .format(post.timestamp.toDate()),
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                    
                                  ],
                                ),
                                
                              ],
                            ),
                            const SizedBox(width: 20.0),
                                post.postImage != null
                                    ? Container(padding: const EdgeInsets.all(5.0), width:300,height:300, child:Image.network(post.postImage!,scale: 0.5,width: 100,height: 100,fit: BoxFit.cover,))
                                    : Text(
                              post.comment??"",
                              style: const TextStyle(fontSize: 16.0),
                            ),
                            const SizedBox(height: 8.0),
                            
                            const SizedBox(height: 4.0),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [




 ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetail(postdetail: post),
      ),
    );
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 0, 5, 8),
    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ), // Choose a color for the button
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: const[
      const Icon(
        Icons.add,
        size: 20.0,
        color: Colors.white, // Choose an appropriate color for the icon
      ),
      const SizedBox(width: 4.0),
      Text(
        'Comments',
        style: TextStyle(
          color: Colors.white, // Choose an appropriate color for the text
        ),
      ),
    ],
  ),
)
                                  // IconButton(
                                  //     onPressed: () {
                                  //       Navigator.push(
                                  //           context,
                                  //           MaterialPageRoute(
                                  //               builder: (context) =>
                                  //                   PostDetail(
                                  //                       postdetail:
                                  //                           post)));
                                  //     },
                                  //     icon: const Icon(
                                  //       Icons.comment_outlined,
                                  //       size: 20.0,
                                  //     )
                                  //     ),
                                  // IconButton(
                                  //   ,
                                  //
                                  // ),
                                  // const SizedBox(width: 4.0),
                                ]),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

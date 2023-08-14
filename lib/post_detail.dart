import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mentalhealthcare/models/commentsmodel.dart';
import 'package:profanity_filter/profanity_filter.dart';

import 'models/Posts.dart';

class PostDetail extends StatefulWidget {
  final Post postdetail;
   const PostDetail({super.key, required this.postdetail});

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
// late Post widget.postdetail;
   bool hasOffensiveContent(String text) {
    final filter = ProfanityFilter();
    final filteredWords = filter.getAllProfanity(text);
    // You can customize how you handle the filtered words if needed
    return filteredWords.isNotEmpty;
  }

final TextEditingController commentController1 = TextEditingController();

  Future<void> saveComment() async {
    final String comment = commentController1.text;
    // ignore: no_leading_underscores_for_local_identifiers
    final _currentUser = FirebaseAuth.instance.currentUser;
    if (_currentUser != null) {
      final String commenterUsername = await getUsernameForOwnerID1(_currentUser.uid);
      final String commenterprofileimage = await getUserProfileImageURL1(_currentUser.uid);
      

      // Upload the image to Firebase Storage and get the image URL
      if (hasOffensiveContent(comment) ) {
        // Show an alert dialog to inform the user about offensive comment
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Offensive Content Detected'),
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
      }else{Comments commentsection = Comments(
       comment:comment,
       timestamp:Timestamp.now(),
       commenterUsername:commenterUsername,
      commenterprofileimage:commenterprofileimage,
      );
 final CollectionReference<Map<String, dynamic>> commentCollection =
      FirebaseFirestore.instance.collection('posts/${widget.postdetail.postid}/comments'); 
      
      await commentCollection.add(commentsection.toMap());
      commentController1.clear();}
    
    }
  }

Future<String> getUsernameForOwnerID1(String ownerid) async {
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

  Future<String> getUserProfileImageURL1(String ownerid) async {
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

  Stream<List<Comments>> fetchCommentStream() {
    final CollectionReference<Map<String, dynamic>> commentCollection =
      FirebaseFirestore.instance.collection('posts/${widget.postdetail.postid}/comments'); 

  return commentCollection
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((querySnapshot) {
    return querySnapshot.docs.map((doc) => Comments.fromMap(doc.data())).toList();
  });
}

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      
    appBar: AppBar(title: const Text("Comments Page")),
    body:SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics:  const BouncingScrollPhysics(),
      child: Container(
                            decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: const Color.fromRGBO(0, 0, 0, 0.024),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: widget.postdetail.profileimage != null
                                        ? NetworkImage(widget.postdetail.profileimage!)
                                            as ImageProvider
                                        : const AssetImage(
                                            'assets/profilepicicon.jpg',
                                          ),
                                    radius: 20.0,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        '${widget.postdetail.username}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        DateFormat('MMM d')
                                            .format(widget.postdetail.timestamp.toDate()),
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                
                                ],
                              ),
                              const SizedBox(width: 10.0),
                                  widget.postdetail.postImage != null
                                      ? Container(padding: const EdgeInsets.all(5.0), width:300,height:300, child:Image.network(widget.postdetail.postImage!,scale: 0.5,width: 100,height: 100,fit: BoxFit.cover,))
                                      : Text(                                                                    widget.postdetail.comment??"",
                                   style: const TextStyle(fontSize: 16.0),
                                      ),
                          
                              // const SizedBox(height: 8.0),
                              // Text(
                              //   widget.postdetail.comment??"",
                              //   style: const TextStyle(fontSize: 16.0),
                              // ),
                              const SizedBox(height: 4.0),
                              Row(
                                              children: [
                                                Expanded(
                                                  child: TextFormField(
                                                      controller: commentController1,
                                                      decoration:  const InputDecoration(
                                                        hintText: 'Write your comment...',
                                                        ),
                                                       autofocus: true,
                                                      keyboardType: TextInputType.text,
                                                  ),
                                                ),
                                                
                                                IconButton(
                                                  onPressed: saveComment,
                                                  icon: const Icon(Icons.send),
                                                ),
                                              ],
                                            ),
                          
                                    SizedBox(
                          
                                      child: Flexible(
                                        fit: FlexFit.loose,
                                        child: StreamBuilder<List<Comments>>(
                                        stream: fetchCommentStream(),
                                        builder: (context, snapshot){
                                           if (snapshot.hasError) {
                                            return const Text('Something went wrong');
                                          }
                                        
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return const Center(child: CircularProgressIndicator());
                                          }
                                           final List<Comments>? comments1 = snapshot.data;
                                           if (comments1 == null || comments1.isEmpty) {
                                            return const Text('No comments available');
                                          }
                                        
                                          return Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              // ignore: avoid_unnecessary_containers
                                             
                                              Card(
                                                elevation: 10.0,
                                                child: ListView.builder(
                                                   physics: const NeverScrollableScrollPhysics(),
                                                   shrinkWrap: true,
                                                  itemCount: comments1.length,
                                                  itemBuilder: (context, index) {
                          final commentsection1 = comments1[index];
                              
                          return Container(
                            
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
                                      backgroundImage: commentsection1.commenterprofileimage != null
                                          ? NetworkImage(commentsection1.commenterprofileimage!)
                                              as ImageProvider
                                          : const AssetImage(
                                              'assets/profilepicicon.jpg',
                                            ),
                                      radius: 20.0,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          commentsection1.commenterUsername??"",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          DateFormat('MMM d')
                                              .format(commentsection1.timestamp.toDate()),
                                          style:
                                              const TextStyle(color: Colors.grey),
                                        ),
                                        
                                      ],
                                    ),
                                    
                                  ],
                                ),
                                const SizedBox(width: 20.0),
                                     Text(
                                  commentsection1.comment??"",
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                                const SizedBox(height: 8.0),
                                                                                                
                              ],
                            ),
                          );
                                                  },
                                                ),
                                              ),
                                            ],
                                          );
                                          
                                        
                                        
                                        
                                        },
                                               
                                            ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
    ),

    );
  }
}

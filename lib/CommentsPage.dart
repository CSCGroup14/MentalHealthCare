// import 'package:flutter/material.dart';

// class CommentsPage extends StatefulWidget {
//   const CommentsPage({super.key});

//   @override
//   State<CommentsPage> createState() => _CommentsPageState();
// }

// class _CommentsPageState extends State<CommentsPage> {
//     Future<void> savePost() async {
//     final String comment = _commentController.text;
//     // ignore: no_leading_underscores_for_local_identifiers
//     final _currentUser = FirebaseAuth.instance.currentUser;
//     if (_currentUser != null) {
//       final String username = await getUsernameForOwnerID(_currentUser.uid);
//       final String profileimage =
//           await getUserProfileImageURL(_currentUser.uid);
//       final String? postImage = await getImage();

//       // Upload the image to Firebase Storage and get the image URL

//       final post = Post(
//         ownerID: _currentUser.uid,
//         comment: comment,
//         timestamp: Timestamp.now(),
//         username: username,
//         profileimage: profileimage,
//         postImage: postImage,
//       );

//       await postsCollection.add(post.toMap());
//       _commentController.clear();
//     }
//   }

//   Future<List<Post>> fetchPosts() async {
//     try {
//       final QuerySnapshot<Map<String, dynamic>> querySnapshot  = 
//       await postsCollection.orderBy('timestamp', descending: true).get();

//       return querySnapshot.docs.map((doc) => Post.fromMap(doc.data())).toList();
//     } catch (e) {
//       print("Error fetching posts: $e");
//       return [];
//     }
//   }



//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(225, 247, 248, 248),
//         appBar: AppBar(
//           title: const Text("MainPage"),
          
//         ),
//         body: FutureBuilder<List<Post>>(
//           future: fetchPosts(),
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return const Text('Something went wrong');
//             }

//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }
            
//             final List<Post>? posts = snapshot.data;

//             if (posts == null || posts.isEmpty) {
//               return const Text('No posts available');
//             }
//             return Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                // ignore: avoid_unnecessary_containers
//                Container(
//                 decoration: BoxDecoration( 
//                 color: Colors.white,
//                border: Border.all(
//               color: const Color.fromARGB(6, 247, 244, 244),
//               width: 1.0,
//               ),
//                             borderRadius: BorderRadius.circular(1.0),
//                           ),
//                  child: Row(
//                   children: [
//                   Expanded(
//                     child: TextFormField(
//                       controller: _commentController,
//                       decoration: const InputDecoration(
//                         hintText: 'What is on your mind...',
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: getImage,
//                     icon: const Icon(Icons.image),
//                   ),
//                   IconButton(
//                     onPressed: savePost,
//                     icon: const Icon(Icons.send),
//                   ),
//                              ],
//                            ),
//                ),
//                 Expanded(
//                   child: Card(
//                     elevation: 30.0,
                    
//                     child: ListView.builder(
//                       itemCount: posts.length,
//                       itemBuilder: (context, index) {
//                         final post = posts[index];

//                         return Container(
                          
//                           width: 200.0,
//                           decoration: BoxDecoration( 
//                           color: Colors.white,
//                           border: Border.all(
//                            color: const Color.fromARGB(6, 0, 0, 0),
//                            width: 2.0,
//                              ),
//                             borderRadius: BorderRadius.circular(5.0),
//                           ),
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   CircleAvatar(
//                                     backgroundImage: post.profileimage != null
//                                         ? NetworkImage(post.profileimage!)
//                                             as ImageProvider
//                                         : const AssetImage(
//                                             'assets/profilepicicon.jpg',
//                                           ),
//                                     radius: 20.0,
//                                   ),
                                  
//                                     Column(
//                                      children: [
//                                       Text(
//                                     '${post.username}',
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                        Text(
//                                 DateFormat('MMM d').format(post.timestamp.toDate()),
//                                 style: const TextStyle(color: Colors.grey),
//                               ),
//                                      ],
//                                    ),
//                                   const SizedBox(width: 8.0),
//                                   post.postImage != null
//                                       ? Container(
//                                           height:
//                                               200, // Adjust the height as needed
//                                           decoration: BoxDecoration(
//                                             image: DecorationImage(
//                                               image:
//                                                   NetworkImage(post.postImage!),
//                                               fit: BoxFit.cover,
//                                             ),
//                                           ),
//                                         )
//                                       : const SizedBox(height: 8.0),
//                                 ],
//                               ),
//                               const SizedBox(height: 8.0),
                             
//                               Text(
//                                 post.comment,
//                                 style: const TextStyle(fontSize: 16.0),
//                               ),
//                               const SizedBox(height: 4.0),
//                               Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: const [
//                                     Icon(
//                                       Icons.comment,
//                                       size: 20.0,
//                                     ),
//                                     SizedBox(width: 4.0),
                                 
//                                   ]),
//                             ],
//                           ),
                        
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//         );
//   }
// }
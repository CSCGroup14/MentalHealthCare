import "package:flutter/material.dart";
import "package:intl/intl.dart";

import "../models/Posts.dart";
import "../post_detail.dart";


class PostScreen extends StatelessWidget {
  const PostScreen({
    super.key,
    required this.posts,
  });

  final List<Post>? posts;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 30.0,
        child: ListView.builder(
          itemCount: posts?.length,
          itemBuilder: (context, index) {
            final post = posts![index];
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
                      ? Container(
                          padding: const EdgeInsets.all(5.0),
                          width: 300,
                          height: 300,
                          child: Image.network(
                            post.postImage!,
                            scale: 0.5,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ))
                      : Text(
                          post.comment ?? "",
                          style: const TextStyle(fontSize: 16.0),
                        ),
                  const SizedBox(height: 8.0),
                  
                  Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PostDetail(postdetail: post),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 0, 5, 8),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(30.0),
                            ), // Choose a color for the button
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              const Icon(
                                Icons.add,
                                size: 20.0,
                                color: Colors
                                    .white, // Choose an appropriate color for the icon
                              ),
                              const SizedBox(width: 4.0),
                              Text(
                                'Comments',
                                style: TextStyle(
                                  color: Colors
                                      .white, // Choose an appropriate color for the text
                                ),
                              ),
                            ],
                          ),
                        )
                       
                      ]),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

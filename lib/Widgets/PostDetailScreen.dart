import "package:flutter/material.dart";
import "package:intl/intl.dart";

import "../models/commentsmodel.dart";

class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({
    super.key,
    required this.commentsection1,
  });

  final Comments commentsection1;

  @override
  Widget build(BuildContext context) {
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
  }
}
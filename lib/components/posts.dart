import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore package
import 'package:random_avatar/random_avatar.dart'; // RandomAvatar package

class Posts extends StatelessWidget {
  final Function(String title, String content)
  onPostTap; // Callback for post tap

  const Posts({Key? key, required this.onPostTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
        if (snapshots.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshots.hasData || snapshots.data!.docs.isEmpty) {
          return Center(
            child: Text("No data found", style: TextStyle(color: Colors.white)),
          );
        }

        final posts = snapshots.data!.docs;

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];

            // Ensure that the title and content are not null
            final title = post['title'] ?? 'No Title';
            final content = post['content'] ?? 'No Content';
            final date = post['date'] ?? 'No Date';

            return GestureDetector(
              onTap: () {
                // Call the onPostTap function with the post details
                onPostTap(title, content);
              },
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(right: 15),
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow:
                                TextOverflow.ellipsis, // Handle long titles
                          ),
                          SizedBox(height: 5),
                          Text(
                            date,
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ), // Add space between text and avatar
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.transparent,
                      child: RandomAvatar(
                        FirebaseAuth.instance.currentUser!.uid,
                        width: 70,
                        height: 70,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

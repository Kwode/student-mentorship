import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';

class Posts extends StatelessWidget {
  final Function(String title, String content) onPostTap;

  const Posts({Key? key, required this.onPostTap}) : super(key: key);

  // Fetch avatar seed from Firestore
  Future<String> getAvatarSeed(String userId) async {
    final doc = await FirebaseFirestore.instance.collection('userinfo').doc(userId).get();
    if (doc.exists && doc.data()!.containsKey('imageUrl')) {
      return doc['imageUrl'];
    }
    return "default";
  }

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
            child: Text("No posts yet", style: TextStyle(color: Colors.white)),
          );
        }

        final posts = snapshots.data!.docs;

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            final title = post['title'] ?? 'No Title';
            final content = post['content'] ?? 'No Content';
            final date = post['date'] ?? 'No Date';
            final userId = post['userId'] ?? '';

            return FutureBuilder<String>(
              future: getAvatarSeed(userId),
              builder: (context, snapshot) {
                final avatarSeed = snapshot.data ?? "default";

                return GestureDetector(
                  onTap: () => onPostTap(title, content),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(right: 15),
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 5),
                        Text(
                          content,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white70),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              date,
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            RandomAvatar(avatarSeed, height: 40, width: 40),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

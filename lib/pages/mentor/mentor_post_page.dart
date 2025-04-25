import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:untitled1/pages/mentee/mentee_create_dart.dart';

class MentorPostPage extends StatefulWidget {
  @override
  _MentorPostPageState createState() => _MentorPostPageState();
}

class _MentorPostPageState extends State<MentorPostPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String _userId;

  @override
  void initState() {
    super.initState();
    _userId = _auth.currentUser!.uid; // Get the logged-in user's ID
  }

  // Function to delete a post
  Future<void> _deletePost(String postId) async {
    await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Post deleted')));
  }

  // Function to navigate to the create post page
  void _createPost() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreatePostPage(userId: _userId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: Text("Your Posts", style: TextStyle(color: Colors.white)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('posts')
                .where(
                  'userId',
                  isEqualTo: _userId,
                ) // Get posts from the logged-in user
                .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final posts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: RandomAvatar(
                    FirebaseAuth
                        .instance
                        .currentUser!
                        .uid, // Generate random avatar based on the user's name/ID
                    width: 40,
                    height: 40,
                  ),
                ),
                title: Text(
                  post['title'],
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  post['date'],
                  style: TextStyle(color: Colors.grey[700]),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deletePost(post.id), // Delete the post
                ),
                onTap: () {
                  // You can add more functionality like viewing the full post or editing it
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePostPage(userId: _userId),
            ),
          );
        }, // Open create post page
        child: Icon(Icons.add, color: Colors.white),
        tooltip: 'Create Post',
      ),
    );
  }
}

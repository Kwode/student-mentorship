import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreatePostPage extends StatefulWidget {
  final String userId; // Declare the userId parameter

  const CreatePostPage({Key? key, required this.userId}) : super(key: key); // Pass userId through constructor

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  // Function to save the post
  Future<void> _savePost() async {
    if (_titleController.text.isEmpty || _dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all fields')));
      return;
    }

    // Save the post to Firestore
    await FirebaseFirestore.instance.collection('posts').add({
      'title': _titleController.text,
      'date': _dateController.text,
      'userId': widget.userId, // Use the passed userId
      'userName': 'User ${widget.userId}', // Optional: Use user ID or name for avatar
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Post added successfully')));
    Navigator.pop(context); // Return to the posts page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create New Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(labelText: 'Date'),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: _savePost,
              child: Text('Save Post'),
            ),
          ],
        ),
      ),
    );
  }
}

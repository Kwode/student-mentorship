import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreatePostPage extends StatefulWidget {
  final String userId;

  const CreatePostPage({Key? key, required this.userId}) : super(key: key);

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  Future<void> _savePost() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    await FirebaseFirestore.instance.collection('posts').add({
      'title': _titleController.text,
      'date': DateTime.now().toString(), // Save the current date
      'content': _contentController.text,
      'userId': widget.userId,
      'userName': 'User   ${widget.userId}',
      'timestamp': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Post added successfully')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create New Post',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue, // Blue app bar
        iconTheme: const IconThemeData(color: Colors.white), // White icon theme
      ),
      backgroundColor: Colors.black, // Dark background
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white), // White text
              decoration: const InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.white70), // Light label
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white70,
                  ), // Light underline
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ), // Blue underline when focused
                ),
              ),
            ),
            TextField(
              controller: _contentController,
              style: const TextStyle(color: Colors.white), // White text
              decoration: const InputDecoration(
                labelText: 'Content',
                labelStyle: TextStyle(color: Colors.white70), // Light label
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white70,
                  ), // Light underline
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ), // Blue underline when focused
                ),
              ),
              maxLines: 5,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _savePost,
              child: const Text('Save Post'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue, // Text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
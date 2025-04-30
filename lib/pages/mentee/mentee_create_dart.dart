import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreatePostPage extends StatefulWidget {
  final String userId;

  const CreatePostPage({Key? key, required this.userId}) : super(key: key);

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _contentController = TextEditingController(); // NEW

  // Function to save the post
  Future<void> _savePost() async {
    if (_titleController.text.isEmpty ||
        _dateController.text.isEmpty ||
        _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('posts').add({
      'title': _titleController.text,
      'date': _dateController.text,
      'content': _contentController.text, // NEW
      'userId': widget.userId,
      'userName': 'User ${widget.userId}',
      'timestamp': FieldValue.serverTimestamp(), // Optional for sorting
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Post added successfully')),
    );
    Navigator.pop(context);
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
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: 5,
            ),
            Spacer(),
            ElevatedButton(onPressed: _savePost, child: Text('Save Post')),
          ],
        ),
      ),
    );
  }
}

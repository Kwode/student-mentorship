import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final TextEditingController _taskController = TextEditingController();
  final CollectionReference tasksCollection = FirebaseFirestore.instance
      .collection('tasks');

  void _addTask() async {
    final String taskTitle = _taskController.text.trim();
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (taskTitle.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Task title cannot be empty')));
      return;
    }
    if (currentUser == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('User not logged in')));
      return;
    }
    try {
      await tasksCollection.add({
        'title': taskTitle,
        'userId': currentUser.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
      _taskController.clear();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Task added')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to add task: $e')));
    }
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back)),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Add Tasks', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _taskController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Task Title',
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[850],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.blueAccent),
                ),
              ),
              onSubmitted: (_) => _addTask(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              onPressed: _addTask,
              child: const Text('Add Task'),
            ),
            const SizedBox(height: 24),
            Expanded(
              child:
              currentUser == null
                  ? const Center(
                child: Text(
                  'User not logged in',
                  style: TextStyle(color: Colors.white),
                ),
              )
                  : StreamBuilder<QuerySnapshot>(
                stream:
                tasksCollection
                    .where('userId', isEqualTo: currentUser.uid)
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!snapshot.hasData ||
                      snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No tasks yet',
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }
                  final tasks = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return ListTile(
                        title: Text(
                          task['title'] ?? '',
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
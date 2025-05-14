import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:untitled1/components/category_selection.dart';
import '../posts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _showPostDetailsDialog(
      BuildContext context,
      String title,
      String content,
      ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Text(
              content,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
          actions: [
            TextButton(
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.blueAccent),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<DocumentSnapshot>(
        future:
        FirebaseFirestore.instance.collection("userinfo").doc(userId).get(),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            );
          }
          if (!snapshots.hasData || !snapshots.data!.exists) {
            return const Center(
              child: Text(
                "No data found",
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(top: 70.0, left: 15, right: 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Welcome, ${snapshots.data?["name"]}",
                      style: GoogleFonts.tiroTamil(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "mentorprofile");
                      },
                      child: CircleAvatar(
                        radius: 25,
                        child: RandomAvatar(
                          snapshots.data?["imageUrl"],
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Search bar
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          hintText: "Search",
                          hintStyle: const TextStyle(color: Colors.white),
                          suffixIcon: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Filter icon
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: const Icon(
                        Icons.tune,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // Category selection
                CategorySelection(),
                const SizedBox(height: 50),
                // Featured posts text
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Featured Posts",
                    style: GoogleFonts.tiroTamil(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Posts with onPostTap callback
                SizedBox(
                  height: 100,
                  child: Posts(
                    onPostTap: (title, content) {
                      _showPostDetailsDialog(context, title, content);
                    },
                  ),
                ),
                const SizedBox(height: 35),
                // Tasks header
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Tasks",
                    style: GoogleFonts.tiroTamil(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Tasks list from Firestore with date display
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream:
                    FirebaseFirestore.instance
                        .collection('tasks')
                        .where('userId', isEqualTo: userId)
                        .orderBy('createdAt', descending: true)
                        .snapshots(),
                    builder: (context, taskSnapshot) {
                      if (taskSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.blue),
                        );
                      }
                      if (!taskSnapshot.hasData ||
                          taskSnapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text(
                            "No tasks found",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }
                      final tasks = taskSnapshot.data!.docs;
                      return ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          // Parse date from Timestamp to DateTime
                          Timestamp? timestamp = task['createdAt'];
                          String formattedDate = '';
                          if (timestamp != null) {
                            DateTime date = timestamp.toDate();
                            formattedDate =
                            "${date.day}/${date.month}/${date.year}";
                          }
                          return ListTile(
                            title: Text(
                              task['title'] ?? 'No Title',
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle:
                            formattedDate.isNotEmpty
                                ? Text(
                              formattedDate,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            )
                                : null,
                            trailing: GestureDetector(
                              onTap: () async {
                                // Delete the task on checkbox tap
                                await FirebaseFirestore.instance
                                    .collection('tasks')
                                    .doc(task.id)
                                    .delete();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
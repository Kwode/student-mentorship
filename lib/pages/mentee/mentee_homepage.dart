// ... keep all your existing imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:untitled1/components/category_selection.dart';
import 'package:untitled1/pages/mentee/mentee_me.dart';
import 'package:untitled1/pages/posts.dart';
import 'package:untitled1/pages/welcome_page.dart';

class MenteeHomepage extends StatefulWidget {
  const MenteeHomepage({super.key});

  @override
  State<MenteeHomepage> createState() => _MenteeHomePageState();
}

class _MenteeHomePageState extends State<MenteeHomepage> {
  String? username;
  String? avatarSeed;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance.collection('userinfo').doc(uid).get();

    if (doc.exists) {
      setState(() {
        username = doc['name'];
        avatarSeed = doc['imageUrl'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (username == null || avatarSeed == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.blue)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 30.0, top: 50.0, right: 10.0, bottom: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting and Avatar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hi $username!",
                    style: GoogleFonts.tiroTamil(
                      color: Color(0xFF687EFF),
                      fontSize: 29,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MenteeMe()),
                      );
                    },
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey[800],
                      child: ClipOval(
                        child: RandomAvatar(
                          avatarSeed ?? "default",
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Search Bar
              Container(
                height: 40,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[800],
                ),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Search...",
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: Colors.white),
                  ),
                ),
              ),

              SizedBox(height: 30),

              // Category Selection
              CategorySelection(),

              SizedBox(height: 60),

              Text(
                'Featured Posts',
                style: GoogleFonts.tiroTamil(color: Colors.white, fontSize: 22),
              ),

              SizedBox(height: 20),

              Container(
                height: 200,
                child: Posts(
                  onPostTap: (title, content) {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(title),
                        content: Text(content),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Close"),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 30),

              Text(
                'Tasks',
                style: GoogleFonts.tiroTamil(color: Colors.white, fontSize: 22),
              ),

              SizedBox(height: 20),

              // Real-time tasks from Firestore with swipe-to-delete
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('tasks')
                    .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(color: Colors.blue);
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text('No tasks yet', style: TextStyle(color: Colors.white70));
                  }

                  final tasks = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Dismissible(
                        key: Key(task.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) async {
                          await FirebaseFirestore.instance
                              .collection('tasks')
                              .doc(task.id)
                              .delete();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Task deleted')),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 15),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.grey[850],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            task['title'] ?? '',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled1/components/category_selection.dart';
import 'package:untitled1/pages/welcome_page.dart';
import 'package:random_avatar/random_avatar.dart';

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
    // Check if username and avatarSeed are not null before building the UI
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
                        MaterialPageRoute(builder: (context) => const WelcomePage()),
                      );
                    },
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey[800],
                      child: ClipOval(
                        child: RandomAvatar(
                          avatarSeed ?? "default", // Fallback to 'default' if null
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

              // Horizontal Scroll Cards
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(3, (index) {
                    return Container(
                      height: 150,
                      width: 250,
                      margin: EdgeInsets.only(right: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[800],
                      ),
                      child: Center(
                        child: Text(
                          "Card ${index + 1}",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              SizedBox(height: 20),

              Text(
                'Tasks',
                style: GoogleFonts.tiroTamil(color: Colors.white, fontSize: 22),
              ),

              SizedBox(height: 20),

              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: List.generate(3, (index) {
                    return Container(
                      height: 70,
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[800],
                      ),
                      child: Center(
                        child: Text(
                          "task ${index + 1}",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              // Dynamic Page Section
             /* _pages[_selectedIndex],*/
            ],
          ),
        ),
      ),


    );
  }
}

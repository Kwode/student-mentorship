import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:untitled1/components/buttons.dart';

class ProfileSetupPage extends StatefulWidget {
  @override
  _ProfileSetupPageState createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  String avatarSeed = FirebaseAuth.instance.currentUser!.uid; // Unique identifier
  final TextEditingController _usernameController = TextEditingController();

  void navToDash() async {
    await FirebaseFirestore.instance
        .collection("userinfo")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "imageUrl": avatarSeed, // Storing the seed instead of a local path
      "username": _usernameController.text.trim()
    });

    Navigator.pushNamed(context, "dash");
  }

  void logOut() async {
    FirebaseAuth.instance.signOut();
  }

  void refreshAvatar() {
    setState(() {
      avatarSeed = DateTime.now().millisecondsSinceEpoch.toString();
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Profile Setup"),
        actions: [
          IconButton(onPressed: logOut, icon: Icon(Icons.logout)),
        ],
      ),
      body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Select an Avatar:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 30),

                  // Random Avatar
                  GestureDetector(
                    onTap: refreshAvatar,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[800],
                      child: ClipOval(
                        child: RandomAvatar(avatarSeed, width: 100, height: 100),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Tap to refresh avatar",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),

                  SizedBox(height: 30),

                  TextField(
                    style: TextStyle(color: Colors.white),
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: "Enter Username",
                      hintStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.green)),
                    ),
                  ),

                  SizedBox(height: 30),

                  Buttons(
                    text: "Finish",
                    onTap: navToDash,
                  ),
                ],
              ),
            ),
          ),
    );
  }
}

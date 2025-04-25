import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_avatar/random_avatar.dart';

class MentorProfilePage extends StatelessWidget {
  const MentorProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: Text("Profile", style: TextStyle(color: Colors.white)),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder(
          future:
              FirebaseFirestore.instance
                  .collection("userinfo")
                  .doc(userId)
                  .get(),
          builder: (context, snapshots) {
            if (snapshots.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshots.hasData || !snapshots.data!.exists) {
              return Center(
                child: Text(
                  "No data found",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            return Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    "${snapshots.data?["name"]}",
                    style: GoogleFonts.tiroTamil(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    // "${snapshots.data?["dept"]} - ${snapshots.data?["level"]}",
                    "Hey",
                    style: GoogleFonts.tiroTamil(color: Colors.grey[500]),
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: CircleAvatar(
                      radius: 50,
                      child: RandomAvatar(
                        snapshots.data?["imageUrl"],
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

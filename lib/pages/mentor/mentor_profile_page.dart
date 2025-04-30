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
              return Center(
                child: CircularProgressIndicator(color: Colors.blue),
              );
            }
            if (!snapshots.hasData || !snapshots.data!.exists) {
              return Center(
                child: Text(
                  "No data found",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            var userData = snapshots.data!.data()!;
            List<dynamic> interests = userData["preferences"] ?? [];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          child: RandomAvatar(userData["imageUrl"]),
                        ),
                        SizedBox(height: 50),
                        Text(
                          userData["name"] ?? '',
                          style: GoogleFonts.tiroTamil(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        Text(
                          userData["title"] ?? '',
                          style: GoogleFonts.tiroTamil(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 70),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "About Me",
                        style: GoogleFonts.tiroTamil(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        userData["aboutMe"] ?? '',
                        style: GoogleFonts.tiroTamil(
                          color: Colors.grey[500],
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Interests",
                        style: GoogleFonts.tiroTamil(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        //Oyibo why now?
                        child: ListView.builder(
                          itemCount: interests.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Icon(Icons.star, color: Colors.blue),
                              title: Text(
                                interests[index],
                                style: GoogleFonts.tiroTamil(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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

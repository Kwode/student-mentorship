import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_avatar/random_avatar.dart';

class UserProfilePage extends StatefulWidget {
  final String username;
  final String image;
  const UserProfilePage({super.key, required this.username, required this.image});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.more_vert))
        ],
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: Text("Profile", style: TextStyle(color: Colors.white),),
      ),

      body: FutureBuilder(
          future: FirebaseFirestore.instance.collection("userinfo").doc(userId).get(),
          builder: (context, snapshots){
            if(snapshots.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }
            if(!snapshots.hasData || !snapshots.data!.exists){
              return Center(child: Text("No data found"),);
            }

            return Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      child: RandomAvatar(widget.image, width: 100, height: 100),
                    ),

                    SizedBox(height: 30,),

                    Text(
                        widget.username,
                      style: GoogleFonts.tiroTamil(
                        color: Colors.white,
                        fontSize: 30
                      ),
                    ),

                    SizedBox(height: 20,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.phone, color: Colors.white, size: 30,),

                        SizedBox(width: 20,),

                        Icon(Icons.video_call, color: Colors.white, size: 30,),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
      ),
    );
  }
}

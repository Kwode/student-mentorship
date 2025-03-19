import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_avatar/random_avatar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
          future: FirebaseFirestore.instance.collection("userinfo").doc(userId).get(),
          builder: (context, snapshots){
            if(snapshots.connectionState == ConnectionState){
              return Center(child: CircularProgressIndicator(),);
            }
            if(!snapshots.hasData || !snapshots.data!.exists){
              return Center(child: Text("No data found"),);
            }

            return Padding(
              padding: const EdgeInsets.only(top: 70.0, left: 15, right: 15),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Welcome, ${snapshots.data!["username"]}",
                          style: GoogleFonts.tiroTamil(
                              color: Colors.white, fontSize: 25,
                              fontWeight: FontWeight.bold
                          ),
                        ),

                        CircleAvatar(
                          radius: 25,
                          child: RandomAvatar(snapshots.data!["imageUrl"], width: 100, height: 100),
                        ),
                      ],
                    ),

                  SizedBox(height: 40,),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.white)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: Colors.white)
                            ),
                            hintText: "Search",
                            hintStyle: TextStyle(
                              color: Colors.white
                            ),
                            suffixIcon: Icon(Icons.search, color: Colors.white)
                          ),
                        ),
                      ),

                      SizedBox(width: 20,),

                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(40)
                        ),
                          child: Icon(Icons.filter_list, size: 20, color: Colors.white)
                      ),
                    ],
                  )
                ],
              ),
            );
          }
      ),
    );
  }
}

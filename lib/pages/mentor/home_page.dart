import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:untitled1/components/category_selection.dart';

import '../../components/posts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

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
                        Text("Welcome, ${snapshots.data?["username"]}",
                          style: GoogleFonts.tiroTamil(
                              color: Colors.white, fontSize: 25,
                              fontWeight: FontWeight.bold
                          ),
                        ),

                        GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, "mentordash");
                          },
                          child: CircleAvatar(
                            radius: 25,
                            child: RandomAvatar(snapshots.data?["imageUrl"], width: 100, height: 100),
                          ),
                        ),
                      ],
                    ),

                  SizedBox(height: 10,),

                  //search bar
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

                      //filter icon
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(40)
                        ),
                          child: Icon(Icons.tune, size: 30, color: Colors.white)
                      ),
                    ],
                  ),

                  SizedBox(height: 30,),

                  //category selection
                  CategorySelection(),

                  SizedBox(height: 50,),

                  //featured posts text
                  Container(
                    alignment: Alignment.centerLeft, // Aligns text to the left
                    child: Text("Featured Posts", style: GoogleFonts.tiroTamil(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),),
                  ),

                  SizedBox(height: 20,),

                  //Posts
                  SizedBox(
                    height: 100,
                      child: Expanded(child: Posts()
                      )
                  ),

                  SizedBox(height: 35,),

                  Container(
                    alignment: Alignment.centerLeft, // Aligns text to the left
                    child: Text("Tasks", style: GoogleFonts.tiroTamil(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),),
                  ),
                ],
              ),
            );
          }
      ),
    );
  }
}

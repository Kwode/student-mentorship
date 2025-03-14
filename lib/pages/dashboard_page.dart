import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key, this.userId});

  final String? userId;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    String? uid = widget.userId ?? FirebaseAuth.instance.currentUser?.uid;
    print(uid);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Dashboard"),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout)
          ),
        ],
      ),


      body: FutureBuilder(
          future: FirebaseFirestore.instance.collection("userinfo").doc(uid).get(),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}", style: TextStyle(color: Colors.white, fontSize: 40),));
            }
            if (!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists) {
              return Center(child: Text("User not found", style: TextStyle(color: Colors.white, fontSize: 40),));
            }

            Map<String, dynamic>? data = snapshot.data!.data() as Map<String, dynamic>?;

            if (data == null) {
              return Center(child: Text("No data available", style: TextStyle(color: Colors.white, fontSize: 40),));
            }

            return ListTile(
              leading: CircleAvatar(
                backgroundImage: data["imageUrl"] != null
                ? NetworkImage(data["imageUrl"]) as ImageProvider
                    : AssetImage("lib/images/avatar10.jpeg"),
              ),
              title: Text(
                data["email"] ?? "Unknown User",
                style: TextStyle(color: Colors.white),
              ),
            );
          }
      ),
    );
  }
}

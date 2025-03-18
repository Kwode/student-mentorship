import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled1/pages/bsign_up.dart';
import 'package:untitled1/pages/mentee_dashboard.dart';
import 'package:untitled1/pages/mentor_dashboard.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Future<String?> getUserCategory () async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection("userinfo").doc(user.uid).get();

        return doc.exists ? doc.data()!["category"] ?? "Unknown" : "unknown";
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Home"),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();

                if (!mounted) return; // Prevents errors if widget is disposed

                Navigator.pushReplacementNamed(context, "welcome"); // Ensure a fresh start
              },
              icon: Icon(Icons.logout)
          ),
        ],
      ),


      body: FutureBuilder(
          future: getUserCategory(),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }
            if (!snapshot.hasData || snapshot.data == "Unknown") {
              return BsignUp(); // Redirect if category is missing
            }
            return snapshot.data == "Mentor"
                ? MentorDashboard()
                : MenteeDashboard();
          }
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled1/pages/bsign_up.dart';
import 'package:untitled1/pages/mentee/mentee_me.dart';
import 'package:untitled1/pages/mentee/mentee_navpage.dart';
import 'package:untitled1/pages/mentor/mentor_navpage.dart';

class RoutingPage extends StatefulWidget {
  const RoutingPage({super.key});

  @override
  State<RoutingPage> createState() => _RoutingPageState();
}


class _RoutingPageState extends State<RoutingPage> {
  Future<String?> getUserCategory() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection("userinfo")
              .doc(user.uid)
              .get();
      return doc.exists ? doc.data()!["category"] ?? "Unknown" : "unknown";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getUserCategory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.blue));
          }
          if (!snapshot.hasData || snapshot.data == "Unknown") {
            return BsignUp(); // Redirect if category is missing
          }
          return snapshot.data == "Mentor"
              ? MentorNavpage()
              : MenteeNavigation();
        },
      ),
    );
  }
}

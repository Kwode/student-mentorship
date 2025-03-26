import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/components/buttons.dart';

class MentorDashboardPage extends StatefulWidget {
  const MentorDashboardPage({super.key});

  @override
  State<MentorDashboardPage> createState() => _MentorDashboardPageState();
}

class _MentorDashboardPageState extends State<MentorDashboardPage> {
  void signOUt () {
    FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, "welcome");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Buttons(text: "Logout", onTap: signOUt),
      ),
    );
  }
}

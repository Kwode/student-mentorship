import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/components/buttons.dart';

class MenteeDashboardPage extends StatelessWidget {
  const MenteeDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Buttons(text: "Logout", onTap: FirebaseAuth.instance.signOut),
      ),
    );
  }
}

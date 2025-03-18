import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/firebase_options.dart';
import 'package:untitled1/pages/bsign_up.dart';
import 'package:untitled1/pages/dashboard_page.dart';
import 'package:untitled1/pages/login_page.dart';
import 'package:untitled1/pages/mentee_dashboard.dart';
import 'package:untitled1/pages/mentor_dashboard.dart';
import 'package:untitled1/pages/sign_up_page.dart';
import 'package:untitled1/pages/welcome_page.dart';
import 'package:untitled1/pages/profile_setup_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData && snapshot.data != null) {
            // User is logged in, check role
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection("users") // Ensure this matches Firestore collection
                  .doc(snapshot.data!.uid)
                  .get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (userSnapshot.hasData && userSnapshot.data!.exists) {
                  String category = userSnapshot.data!.get("category");
                  if (category == "Mentor") {
                    return MentorDashboard();
                  } else {
                    return MenteeDashboard();
                  }
                } else {
                  return ProfileSetupPage(); // If user has no profile, send to setup
                }
              },
            );
          } else {
            return const LoginPage(); // Not logged in
          }
        },
      ),


      routes: {
        "signin": (context) => LoginPage(),
        "signup": (context) => SignUpPage(),
        "bsign": (context) => BsignUp(),
        "profile": (context) => ProfileSetupPage(),
        "dash": (context) => DashboardPage(),
        "mentor": (context) => MentorDashboard(),
        "mentee": (context) => MenteeDashboard(),
        "welcome": (context) => WelcomePage(),
      },
    );
  }
}

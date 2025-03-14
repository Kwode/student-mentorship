import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/firebase_options.dart';
import 'package:untitled1/pages/bsign_up.dart';
import 'package:untitled1/pages/dashboard_page.dart';
import 'package:untitled1/pages/login_page.dart';
import 'package:untitled1/pages/sign_up_page.dart';
import 'package:untitled1/pages/welcome_page.dart';
import 'package:untitled1/pages/profile_setup_page.dart';
import 'package:firebase_core/firebase_core.dart';

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
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if(snapshot.data != null){
            return DashboardPage();
          }
          return LoginPage();
        }
      ),

      routes: {
        "signin": (context) => LoginPage(),
        "signup": (context) => SignUpPage(),
        "bsign": (context) => BsignUp(),
        "profile": (context) => ProfileSetupPage(),
        "dash": (context) => DashboardPage(),
      },
    );
  }
}

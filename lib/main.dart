import 'package:flutter/material.dart';
import 'package:untitled1/pages/bsign_up.dart';
import 'package:untitled1/pages/login_page.dart';
import 'package:untitled1/pages/sign_up_page.dart';
import 'package:untitled1/pages/welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),

      routes: {
        "signin": (context) => LoginPage(),
        "signup": (context) => SignUpPage(),
        "bsign": (context) => BsignUp(),
      },
    );
  }
}

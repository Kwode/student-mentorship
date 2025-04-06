// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
//
// class AuthModel extends ChangeNotifier{
//   final _auth = FirebaseAuth.instance;
//   final _firestore = FirebaseFirestore.instance;
//
//   // Future<void> signIn(String email, String password) async {
//   //   try {
//   //     UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
//   //
//   //     String uid = userCredential.user!.uid; // Get user ID
//   //
//   //     print("Logged in successfully: $uid");
//   //
//   //     //Check if the user exists in Firestore
//   //     await checkUserExists(uid);
//   //
//   //     //Navigate to Dashboard after login
//   //     if (mounted) {
//   //       Navigator.pushReplacement(
//   //         context,
//   //         MaterialPageRoute(builder: (context) => DashboardPage()),
//   //       );
//   //     }
//   //   } catch (e) {
//   //     print("Error during sign-in: $e");
//   //   }
//   }
// }
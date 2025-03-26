import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CategorySelection extends StatefulWidget {
  @override
  _CategorySelectionState createState() => _CategorySelectionState();
}

class _CategorySelectionState extends State<CategorySelection> {
  final user = FirebaseAuth.instance.currentUser;

  // Future<String?> getCategory () async {
  //   if (user != null) {
  //     final doc = await FirebaseFirestore.instance.collection("userinfo").doc(user.uid).get();
  //     return doc.exists ? doc.data()!["category"] ?? "Unknown" : "unknown";
  //   }
  //   return null;
  //

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: FutureBuilder(
        future: FirebaseFirestore.instance.collection("userinfo").doc(user!.uid).get(),
        builder:(context, snapshots){
          String selectedCategory = "${snapshots.data!["preferences"][0]}"; // Default selected category

          final List<dynamic> categories = snapshots.data!["preferences"];

          if(snapshots.connectionState == ConnectionState){
            return Center(child: CircularProgressIndicator(),);
          }
          if(!snapshots.hasData || !snapshots.data!.exists){
            return Center(child: Text("No data found"),);
          }

          return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: categories.map((category) {
            bool isSelected = category == selectedCategory;
            return Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCategory = category;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue : Colors.grey[900],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
       }
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Dashboard"),
      ),

      body: Center(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("userinfo").snapshots(),
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: 1,
                itemBuilder: (context, index){
                  return Center(
                    child: Text(
                      "Welcome, ${snapshot.data!.docs[index].data()["name"]}",
                      style: GoogleFonts.tiroTamil(
                        color: Colors.white,
                        fontSize: 40
                      ),
                    ),
                  );
                }
            );
          },
        ),
      ),
    );
  }
}

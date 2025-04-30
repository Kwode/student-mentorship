import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/pages/mentee/interest_content.dart';

import '../preferences_page.dart';


class MenteeInterestsPage extends StatefulWidget{
  const MenteeInterestsPage({super.key});

  @override
  State<MenteeInterestsPage> createState() => _MenteeInterestsState();
}

class _MenteeInterestsState extends State<MenteeInterestsPage> {

  List<String> interests = [];

  @override
  void initState() {
    super.initState();
    fetchUserInterests();
  }

  Future<void> fetchUserInterests() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final doc = await FirebaseFirestore.instance.collection('userinfo').doc(userId).get();
    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      final List<dynamic> interestList = data['preferences'] ?? [];

      setState(() {
        interests = interestList.map((e) => e.toString()).toList();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF687EFF),
        title: const Text('Interests'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  tooltip: 'Edit Preferences',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PreferencesPage(
                          userCategory: "Mentee",
                        ),
                      ),
                    );
                  },
                ),

              ],
            ),

            SizedBox(height: 40),
            Expanded(
              child: interests.isEmpty
                  ? const Center(
                child: Text(
                  'No interests found',
                  style: TextStyle(color: Colors.white),
                ),
              )
                  : ListView.builder(
                itemCount: interests.length,
                itemBuilder: (context, index) {
                  String interest = interests[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              InterestDetailPage(interest: interest),
                        ),
                      );
                    },
                    child: Container(
                      height: 70,
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Color(0xFF80B3FF),
                      ),
                      child: Center(
                        child: Text(
                          interest,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}

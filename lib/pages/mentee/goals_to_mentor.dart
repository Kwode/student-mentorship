import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart'; // make sure you have this imported!

class SelectMentorForMilestone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color(0xFF687EFF),
        title: Text("Select Mentor"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('connections')
            .where('status', isEqualTo: 'connected')
            .where('from', isEqualTo: currentUserId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.blue));
          }

          final connections = snapshot.data?.docs ?? [];

          if (connections.isEmpty) {
            return Center(
              child: Text(
                "No mentors found.",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView.builder(
            itemCount: connections.length,
            itemBuilder: (context, index) {
              final connection = connections[index];
              final mentorId = connection['to'];

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('userinfo')
                    .doc(mentorId)
                    .get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData || userSnapshot.data == null || !userSnapshot.data!.exists) {
                    return SizedBox.shrink();
                  }

                  final data = userSnapshot.data!.data() as Map<String, dynamic>;
                  final name = data['name'] ?? 'No Name';
                  final category = data['category'] ?? '';
                  final image = data['imageUrl'] ?? 'defaultseed'; // fallback seed for avatar

                  return Card(
                    color: Colors.grey[900],
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 26,
                        backgroundColor: Colors.transparent,
                        child: RandomAvatar(
                          image,
                          width: 40,
                          height: 40,
                        ),
                      ),
                      title: Text(
                        name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        category.toUpperCase(),
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context, mentorId);
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

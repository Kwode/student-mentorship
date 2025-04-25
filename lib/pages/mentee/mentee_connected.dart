import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:untitled1/pages/mentee/mentee_chat_room.dart';

class Connected extends StatelessWidget {
  const Connected({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('connections')
              .where('from', isEqualTo: currentUserId)
              .where('status', isEqualTo: 'connected')
              .snapshots(),
      builder: (context, connectionSnapshot) {
        if (connectionSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!connectionSnapshot.hasData ||
            connectionSnapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              "No connected mentors yet.",
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        final connections = connectionSnapshot.data!.docs;

        return ListView.builder(
          itemCount: connections.length,
          itemBuilder: (context, index) {
            final mentorId =
                connections[index]['to']; // changed from 'from' to 'to'

            return FutureBuilder<DocumentSnapshot>(
              future:
                  FirebaseFirestore.instance
                      .collection('userinfo')
                      .doc(mentorId)
                      .get(),
              builder: (context, mentorSnapshot) {
                if (mentorSnapshot.connectionState == ConnectionState.waiting) {
                  return const ListTile(
                    title: Text(
                      "Loading...",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                if (!mentorSnapshot.hasData || !mentorSnapshot.data!.exists) {
                  return const ListTile(
                    title: Text(
                      "Mentor not found",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                final data =
                    mentorSnapshot.data!.data() as Map<String, dynamic>;
                final name = data['name'] ?? 'No Name';
                final category = data['category'] ?? '';
                final image = data['imageUrl'] ?? 'saytoonz';

                return Card(
                  color: Colors.grey[900],
                  child: ListTile(
                    leading: CircleAvatar(
                      child: RandomAvatar(image, width: 40, height: 40),
                    ),
                    title: Text(
                      name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      category.toUpperCase(),
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: const Icon(Icons.chat, color: Colors.white70),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => MenteeChatRoom(
                                username: name,
                                image: image,
                                receiverId: mentorId,
                              ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

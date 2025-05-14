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

    // Streams for both directions of connection
    final fromStream =
        FirebaseFirestore.instance
            .collection('connections')
            .where('from', isEqualTo: currentUserId)
            .where('status', isEqualTo: 'connected')
            .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: fromStream,
      builder: (context, fromSnapshot) {
        if (fromSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.blue),
          );
        }

        final fromConnections = fromSnapshot.data?.docs ?? [];

        return StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection('connections')
                  .where('to', isEqualTo: currentUserId)
                  .where('status', isEqualTo: 'connected')
                  .snapshots(),
          builder: (context, toSnapshot) {
            if (toSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.blue),
              );
            }

            final toConnections = toSnapshot.data?.docs ?? [];
            final allConnections =
                [
                  ...fromConnections.map((doc) => doc['to']),
                  ...toConnections.map((doc) => doc['from']),
                ].toSet().toList();

            if (allConnections.isEmpty) {
              return const Center(
                child: Text(
                  "No connections yet.",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return ListView.builder(
              itemCount: allConnections.length,
              itemBuilder: (context, index) {
                final userId = allConnections[index];

                return FutureBuilder<DocumentSnapshot>(
                  future:
                      FirebaseFirestore.instance
                          .collection('userinfo')
                          .doc(userId)
                          .get(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const ListTile(
                        title: Text(
                          "Loading...",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                      return const ListTile(
                        title: Text(
                          " ",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    final data = userSnapshot.data!.data() as Map<String, dynamic>;
                    final name = data['name'] ?? 'No Name';
                    final category = data['category'] ?? '';
                    final image = data['imageUrl'] ?? 'saytoonz';

                    return Card(
                      color: Colors.grey[900],
                      child: ListTile(
                        onTap:
                            () => Navigator.pushNamed(context, "mentorprofile"),
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
                        trailing: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ChatRoom(
                                      username: name,
                                      image: image,
                                      receiverId: userId,
                                    ),
                              ),
                            );
                          },
                          icon: Icon(Icons.message, color: Colors.white70),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

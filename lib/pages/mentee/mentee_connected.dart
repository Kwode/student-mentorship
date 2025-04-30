import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:untitled1/pages/mentee/mentee_chat_room.dart';

class Connected extends StatefulWidget {
  const Connected({super.key});

  @override
  State<Connected> createState() => _ConnectedState();
}

class _ConnectedState extends State<Connected> {
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  List<String> allConnections = [];

  @override
  Widget build(BuildContext context) {
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

            // Merge unique connections
            final allConnections =
                [
                  ...fromConnections.map((doc) => doc['to'] as String),
                  ...toConnections.map((doc) => doc['from'] as String),
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
                      return const SizedBox.shrink();
                    }

                    final data =
                        userSnapshot.data!.data() as Map<String, dynamic>;
                    final name = data['name'] ?? 'No Name';
                    final category = data['category'] ?? '';
                    final image = data['imageUrl'] ?? 'saytoonz';

                    return Dismissible(
                      key: Key(userId),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (_) async {
                        return await showDialog(
                          context: context,
                          builder:
                              (_) => AlertDialog(
                                title: Text("Remove Connection"),
                                content: Text(
                                  "Are you sure you want to remove $name?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(false),
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(true),
                                    child: Text("Remove"),
                                  ),
                                ],
                              ),
                        );
                      },
                      onDismissed: (_) async {
                        try {
                          // Find the connection document (from -> to or to -> from)
                          final query =
                              await FirebaseFirestore.instance
                                  .collection('connections')
                                  .where('status', isEqualTo: 'connected')
                                  .where(
                                    'from',
                                    whereIn: [currentUserId, userId],
                                  )
                                  .where('to', whereIn: [currentUserId, userId])
                                  .get();

                          for (var doc in query.docs) {
                            await doc.reference.delete();
                          }

                          setState(() {
                            allConnections.removeAt(index);
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('$name removed from connections'),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error removing connection: $e'),
                            ),
                          );
                        }
                      },
                      child: Card(
                        color: Colors.grey[900],
                        child: ListTile(
                          onTap:
                              () =>
                                  Navigator.pushNamed(context, "mentorprofile"),
                          leading: CircleAvatar(
                            child: RandomAvatar(image, width: 40, height: 40),
                          ),
                          title: Text(
                            name,
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            category.toUpperCase(),
                            style: TextStyle(color: Colors.grey),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => MenteeChatRoom(
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

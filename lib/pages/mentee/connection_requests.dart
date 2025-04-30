import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:untitled1/pages/mentee/mentee_info.dart';

class RequestPage extends StatefulWidget {
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder<QuerySnapshot>(
        stream: fetchReceivedRequestsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF687EFF)),
            );
          }

          if (snapshot.hasError) {
            print("Error: ${snapshot.error}");
            return Center(
              child: Text(
                'Error fetching requests: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No received requests.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final requests = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              final fromUserId = request['from'];

              return FutureBuilder<DocumentSnapshot>(
                future:
                    FirebaseFirestore.instance
                        .collection('userinfo')
                        .doc(fromUserId)
                        .get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(
                      title: Text(
                        "Loading...",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  if (userSnapshot.hasError) {
                    return const ListTile(
                      title: Text(
                        "Error loading user info",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  final userData =
                      userSnapshot.data!.data() as Map<String, dynamic>?;

                  return GestureDetector(
                    onTap: () {
                      // Navigate to the user profile page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MenteeInfo(userId: fromUserId),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.grey[900],
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFF687EFF),
                          child: CircleAvatar(
                            child: RandomAvatar(userData?['imageUrl']),
                          ),
                        ),
                        title: Text(
                          userData?['name'] ?? 'Unknown',
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          userData?['category'] ?? '',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.check_circle,
                                color: Color(0xFF4CAF50),
                                size: 30,
                              ),
                              onPressed: () async {
                                try {
                                  await acceptRequest(request.id, fromUserId);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Request accepted"),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Error accepting request: $e",
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.cancel,
                                color: Color(0xFFF44336),
                                size: 30,
                              ),
                              onPressed: () async {
                                try {
                                  await declineRequest(request.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Request declined"),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Error declining request: $e",
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
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

  Stream<QuerySnapshot> fetchReceivedRequestsStream() {
    final currentUser = FirebaseAuth.instance.currentUser;
    print('Fetching received requests for user: ${currentUser?.uid}');
    return FirebaseFirestore.instance
        .collection('requests')
        .where('to', isEqualTo: currentUser?.uid)
        .where('status', isEqualTo: 'pending')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> acceptRequest(String requestId, String fromUserId) async {
    try {
      // Update the request status to 'accepted'
      await FirebaseFirestore.instance
          .collection('requests')
          .doc(requestId)
          .update({'status': 'accepted'});

      // Optionally, update any other parts of your Firestore data
      await FirebaseFirestore.instance
          .collection('connections')
          .doc(requestId)
          .set({
            'from': fromUserId,
            'to': FirebaseAuth.instance.currentUser?.uid,
            'status': 'connected',
            'timestamp': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      print("Error accepting request: $e");
      throw e;
    }
  }

  Future<void> declineRequest(String requestId) async {
    try {
      // Update the request status to 'declined'
      await FirebaseFirestore.instance
          .collection('requests')
          .doc(requestId)
          .update({'status': 'declined'});
    } catch (e) {
      print("Error declining request: $e");
      throw e;
    }
  }
}

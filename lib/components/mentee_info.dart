import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';

import 'category_selection.dart';

class MenteeInfo extends StatefulWidget {
  final String userId;

  const MenteeInfo({super.key, required this.userId});

  @override
  State<MenteeInfo> createState() => _MenteeInfoState();
}

class _MenteeInfoState extends State<MenteeInfo> {
  User? currentUser;
  String? username;
  String? avatarSeed;
  String? title;
  String? profileSections;
  String? department;
  String? level;
  String? aboutMe;
  List<String>? goals;
  bool notConnected = true; // track if the request has been sent
  late final String userId;

  @override
  void initState() {
    super.initState();
    userId = widget.userId;
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('userinfo')
              .doc(userId)
              .get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        setState(() {
          username = data['name'] ?? 'Anonymous';
          avatarSeed = data['imageUrl'] ?? userId;
          title = data['title'];
          aboutMe = data['aboutMe'];
          profileSections = data['profileSections'];
        });
      } else {
        setState(() {
          username = 'Anonymous';
          avatarSeed = userId;
        });
      }
      await checkRequestStatus();
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        username = 'Anonymous';
        avatarSeed = 'default_avatar';
      });
    }
  }

  // Check if a request has been sent from the current user to the profile user
  Future<void> checkRequestStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final querySnapshot =
        await FirebaseFirestore.instance
            .collection('requests')
            .where('from', isEqualTo: currentUser.uid)
            .where('to', isEqualTo: userId)
            .limit(1)
            .get();

    if (querySnapshot.docs.isNotEmpty) {
      final requestData =
          querySnapshot.docs.first.data() as Map<String, dynamic>;
      final requestStatus = requestData['status'];

      setState(() {
        notConnected = requestStatus == 'pending' ? false : true;
      });
    } else {
      setState(() {
        notConnected = true; // No request found, can send one
      });
    }
  }

  Future<void> sendConnectionRequest(String targetUserId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final requestDoc = FirebaseFirestore.instance.collection('requests').doc();

    await requestDoc.set({
      'from': currentUser.uid,
      'to': targetUserId,
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
    });

    setState(() {
      notConnected = false; // Update UI to show "Request sent"
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Connection request sent")));
  }

  @override
  Widget build(BuildContext context) {
    if (avatarSeed == null || username == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.blue)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF687EFF),
        title: Text(username ?? "Profile"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[800],
                      child: ClipOval(
                        child: RandomAvatar(
                          avatarSeed!,
                          width: 120,
                          height: 120,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      username!,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        Text(
                          title ?? '',
                          style: TextStyle(
                            color: const Color(0xFF687EFF),
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          profileSections ?? '',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: [
                              if (notConnected)
                                OutlinedButton.icon(
                                  onPressed: () async {
                                    await sendConnectionRequest(userId);
                                  },
                                  icon: const Icon(
                                    Icons.send,
                                    color: Color(0xFF687EFF),
                                  ),
                                  label: const Text(
                                    'Send request',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.white),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                )
                              else
                                const Text(
                                  'Request sent',
                                  style: TextStyle(
                                    color: Color(0xFF687EFF),
                                    fontSize: 16,
                                  ),
                                ),
                              const SizedBox(width: 15),
                              OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.message,
                                  color: Color(0xFF687EFF),
                                ),
                                label: const Text(
                                  'Message',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.white),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'About Me',
                style: TextStyle(color: Color(0xFF687EFF), fontSize: 20),
              ),
              const SizedBox(height: 15),
              Text(
                aboutMe ?? '',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'Interests',
                style: TextStyle(color: Color(0xFF687EFF), fontSize: 20),
              ),
              const SizedBox(height: 20),
              CategorySelection(),
            ],
          ),
        ),
      ),
    );
  }
}

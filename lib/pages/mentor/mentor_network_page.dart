import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:untitled1/pages/mentor/mentor_chat_room.dart';

class MentorNetworkPage extends StatefulWidget {
  const MentorNetworkPage({super.key});

  @override
  State<MentorNetworkPage> createState() => _MentorNetworkPageState();
}

class _MentorNetworkPageState extends State<MentorNetworkPage> {
  TextEditingController searchController = TextEditingController();
  List<DocumentSnapshot> allUsers = [];
  List<DocumentSnapshot> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
    fetchUsers();
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    filterUsers();
  }

  void fetchUsers() async {
    FirebaseFirestore.instance.collection("userinfo").snapshots().listen((
      snapshot,
    ) {
      setState(() {
        allUsers = snapshot.docs;
        filterUsers();
      });
    });
  }

  void filterUsers() {
    final query = searchController.text.toLowerCase();

    setState(() {
      filteredUsers =
          allUsers.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final name = (data['name'] ?? '').toString().toLowerCase();
            return name.contains(query) &&
                FirebaseAuth.instance.currentUser?.email != data["email"];
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.only(top: 90.0, left: 5, right: 5),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                hintText: "Search",
                hintStyle: const TextStyle(color: Colors.white),
                suffixIcon: const Icon(Icons.search, color: Colors.white),
              ),
            ),

            // Display Users
            Expanded(
              child:
                  filteredUsers.isEmpty
                      ? const Center(
                        child: Text(
                          "No users found",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                      : ListView(
                        children:
                            filteredUsers
                                .map<Widget>((doc) => _buildUserList(doc))
                                .toList(),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    final username = data['name'] ?? 'No Name';
    final role = data['category'] ?? 'Unknown';
    final image = data['imageUrl'] ?? "saytoonz";
    final uid = data['owner'];

    return Card(
      color: Colors.grey[900],
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => ChatRoom(
                    username: username,
                    image: image,
                    receiverId: uid,
                  ),
            ),
          );
        },
        trailing: const Icon(Icons.arrow_forward_ios),
        leading: CircleAvatar(
          child: RandomAvatar(image, width: 40, height: 40),
        ),
        title: Text(username, style: const TextStyle(color: Colors.white)),
        subtitle: Text(
          role.toUpperCase(),
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}

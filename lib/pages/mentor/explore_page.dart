import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:untitled1/pages/mentor/user_profile_page.dart';


class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {

  void navToProfile(){

  }

  @override
  Widget build(BuildContext context) {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: Colors.black,

      body: Padding(
        padding: const EdgeInsets.only(top: 90.0, left: 5, right: 5),
        child: Column(
            children: [
              //search bar
                  TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.white)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.white)
                      ),
                      hintText: "Search",
                      hintStyle: TextStyle(
                          color: Colors.white
                      ),
                      suffixIcon: Icon(Icons.search, color: Colors.white)
                  ),
                ),

              //display users

              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection("userinfo").snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text("No users found",
                              style: TextStyle(color: Colors.white)),
                        );
                      }

                      return ListView(
                        children: snapshot.data!.docs.map<Widget>((doc) => _buildUserList(doc)).toList(),
                      );
                    }
                ),
              ),
            ],
        ),


      ),
    );
  }
  Widget _buildUserList(DocumentSnapshot document){
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    final username = data['name'] ?? 'No Name';
    final role = data['category'] ?? 'Unknown';
    final image = data['imageUrl'] ?? "saytoonz";
    final uid = data['owner'];

    if (FirebaseAuth.instance.currentUser!.email != data["email"]){
      return Card(
        color: Colors.grey[900],
        child: ListTile(
          onTap: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfilePage(
                    username: username,
                    image: image,
                    receiverId: uid,
                  ),
                )
            );
          },
          trailing: Icon(Icons.arrow_forward_ios),
          leading: CircleAvatar(
            child: RandomAvatar(
              image,
              width: 40,
              height: 40,
            ),
          ),
          title: Text(username, style: TextStyle(color: Colors.white)),
          subtitle: Text(role.toUpperCase(), style: TextStyle(color: Colors.grey)),
        ),
      );
    }else{
      return Container();
    }
  }
}

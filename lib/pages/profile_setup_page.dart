import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/components/buttons.dart';

class ProfileSetupPage extends StatefulWidget {
  @override
  _ProfileSetupPageState createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  List<String> avatarList = [
    "lib/images/avatar1.jpeg",
    "lib/images/avatar2.jpg",
    "lib/images/avatar3.jpg",
    "lib/images/avatar4.jpeg",
    "lib/images/avatar5.jpg",
    "lib/images/avatar6.jpeg",
    "lib/images/avatar7.jpg",
    "lib/images/avatar8.jpeg",
    "lib/images/avatar9.jpg",
    "lib/images/avatar10.jpeg",
    "lib/images/avatar11.jpg",
    "lib/images/avatar12.jpeg",
  ];

  String? selectedAvatar;
  final TextEditingController _usernameController = TextEditingController();
  void navToDash() async{
    await FirebaseFirestore.instance.collection("userinfo").doc(FirebaseAuth.instance.currentUser!.uid).update({
      "imageUrl": selectedAvatar,
      "username": _usernameController.text.trim()
    });
    Navigator.pushNamed(context, "dash");
  }
  
  void logOut() async{
    FirebaseAuth.instance.signOut();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          title: Text("Profile Setup"),
        actions: [
          IconButton(
              onPressed: logOut, 
              icon: Icon(Icons.logout)
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        
              //text
              Text(
                "Select an Avatar:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
        
              SizedBox(height: 30),
        
              //list of avatars
              GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: avatarList.length,
                  itemBuilder: (context, index) {
                    String avatar = avatarList[index];
                    bool isSelected = avatar == selectedAvatar;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedAvatar = avatar;
                        });
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? Colors.blue : Colors.transparent,
                                width: 3,
                              ),
                            ),
                            child: CircleAvatar(
                              backgroundImage: AssetImage(avatar),
                              radius: 70,
                            ),
                          ),
                          if (isSelected)
                            Icon(Icons.check_circle, color: Colors.blue, size: 30),
                        ],
                      ),
                    );
                  },
                ),

                Column(
                  children: [
                    TextField(
                      style: TextStyle(color: Colors.white),
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: "Enter Username",
                        hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.green)
                        ),
                      ),
                    ),
        
                    SizedBox(height: 30),
        
                    Buttons(
                      text: "Finish",
                      onTap: navToDash
                    ),
                  ],
                ),
        
        
            ],
          ),
        ),
      ),
    );
  }
}

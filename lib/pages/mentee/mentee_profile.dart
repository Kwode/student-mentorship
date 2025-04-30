import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/components/badges.dart';
import 'package:untitled1/components/category_selection.dart';
import 'package:random_avatar/random_avatar.dart';

class MenteeProfile extends StatefulWidget {
  const MenteeProfile({super.key});

  @override
  State<MenteeProfile> createState() => _MenteeProfileState();
}

class _MenteeProfileState extends State<MenteeProfile> {
  User? currentUser;
  String? username;
  String? avatarSeed;
  String? title;
  String? profileSections;
  String? department;
  String? level;
  String? aboutMe;
  List<String>? goals;


  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    print("Current User: ${currentUser?.email}");
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print('No logged in user');
      return;
    }

    final uid = user.uid;
    try {
      final doc = await FirebaseFirestore.instance.collection('userinfo').doc(uid).get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        setState(() {
          username = data['name'] ?? 'Anonymous';
          avatarSeed = data['imageUrl'] ?? uid;
          title = data['title'];
          aboutMe = data['aboutMe'];
          profileSections = data['profileSections'];
        });
      } else {
        setState(() {
          username = 'Anonymous';
          avatarSeed = uid;
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        username = 'Anonymous';
        avatarSeed = 'default_avatar';
      });
    }
  }




  // Profile section dialog box
  void _showAddProfileDialog(BuildContext context) {
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _deptController = TextEditingController();
    final TextEditingController _levelController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Complete your profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(hintText: 'Title (e.g. Tech Enthusiast)'),
            ),
            TextField(
              controller: _deptController,
              decoration: InputDecoration(
                hintText: 'Department (e.g. Business Administration)',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _levelController,
              decoration: InputDecoration(
                hintText: 'Level (e.g. 300)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                title = _titleController.text.trim();
                department = _deptController.text.trim();
               level = _levelController.text.trim();
                profileSections = "$department - $level"; // Combine both
              });
              FirebaseFirestore.instance
                  .collection('userinfo')
                  .doc(currentUser?.uid)
                  .set({'profileSections': profileSections}, SetOptions(merge: true));

             FirebaseFirestore.instance
                  .collection('userinfo')
                  .doc(currentUser?.uid)
                  .set({'title': title}, SetOptions(merge: true));

              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  // About me dialog box
  void _showAddAboutDialog(BuildContext context) {
    final TextEditingController _aboutController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Let people know who you are'),
        content: TextField(
          controller: _aboutController,
          decoration: InputDecoration(hintText: 'A good about me is short and captivating'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                aboutMe = _aboutController.text.trim();
              });
              FirebaseFirestore.instance
                  .collection('userinfo')
                  .doc(currentUser?.uid)
                  .set({'aboutMe': aboutMe}, SetOptions(merge: true));

              Navigator.pop(context); // Close dialog
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController aboutMeController = TextEditingController();
    final TextEditingController departmentController = TextEditingController();
    final TextEditingController levelController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            "Edit Profile",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // Title
                _buildInputField("Title", titleController),

                SizedBox(height: 10),

                // About Me
                _buildInputField("About Me", aboutMeController),

                SizedBox(height: 10),

                // Department
                _buildInputField("Department", departmentController),

                SizedBox(height: 10),

                // Level
                _buildInputField("Level", levelController),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () async {
                try {
                  String uid = FirebaseAuth.instance.currentUser!.uid;

                  // Concatenate department and level
                  String profileSection = "${departmentController.text} ${levelController.text}";

                  await FirebaseFirestore.instance.collection('userinfo').doc(uid).update({
                    'title': titleController.text,
                    'aboutMe': aboutMeController.text,
                    'department': departmentController.text,
                    'level': levelController.text,
                    'profileSection': profileSection,
                  });

                  Navigator.of(context).pop(); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Profile updated successfully!')),
                  );
                } catch (e) {
                  print("Error updating profile: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update profile.')),
                  );
                }
              },
              child: Text("Save"),
            ),


          ],
        );
      },
    );
  }

// Custom input field builder for cleaner code
  Widget _buildInputField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

  }


  @override
  Widget build(BuildContext context) {
    if (username == null || avatarSeed == null) {
      // If data is still being fetched, show loading spinner
      return Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.blue)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: username != null && title != null && profileSections != null && aboutMe != null
          ? AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Color(0xFF687EFF)),
            onPressed: () {
               _showEditProfileDialog(context);
            },
          ),
        ],
      )
          : null,
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
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                username!,
                                style: const TextStyle(color: Colors.white, fontSize: 25),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),


                    if (profileSections == null || title == null)
                      OutlinedButton.icon(
                        onPressed: () {
                          _showAddProfileDialog(context);
                        },
                        icon: Icon(Icons.title, color: Colors.white),
                        label: Text(
                          'Add Profile',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.white),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      )
                    else
                      Column(
                        children: [
                          Text(
                            title!,
                            style: TextStyle(color: Color(0xFF687EFF), fontSize: 25),
                          ),
                          SizedBox(height: 5),
                          Text(
                            profileSections!,
                            style: TextStyle(color: Colors.grey[600], fontSize: 16),
                          ),
                        ],
                      ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'About Me',
                style: TextStyle(color: Color(0xFF687EFF), fontSize: 22),
              ),
              const SizedBox(height: 15),
              if (aboutMe == null)
                OutlinedButton.icon(
                  onPressed: () {
                    _showAddAboutDialog(context);
                  },
                  icon: Icon(Icons.title, color: Colors.white),
                  label: Text(
                    'Add About Me',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.white),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                )
              else
                Text(
                  aboutMe!,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              const SizedBox(height: 30),
              Text(
                'Interests',
                style: TextStyle(color: Color(0xFF687EFF), fontSize: 22),
              ),
              const SizedBox(height: 10),
              CategorySelection(),
              const SizedBox(height: 30),
              Text(
                'Badges',
                style: TextStyle(color: Color(0xFF687EFF), fontSize: 22),
              ),
              const SizedBox(height: 10),
              CurrentBadgeWidget(size: 50.0),


            ],
          ),
        ),
      ),
    );
  }
}

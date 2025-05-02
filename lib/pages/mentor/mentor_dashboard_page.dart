import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:untitled1/components/buttons.dart';

class MentorDashboardPage extends StatefulWidget {
  const MentorDashboardPage({super.key});

  @override
  State<MentorDashboardPage> createState() => _MentorDashboardPageState();
}

class _MentorDashboardPageState extends State<MentorDashboardPage> {
  void signOUt() {
    FirebaseAuth.instance.signOut();
  }

  String? userId = FirebaseAuth.instance.currentUser?.uid;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: Text("Dashboard", style: TextStyle(color: Colors.white)),
      ),

      //drawer
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                DrawerHeader(
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),

                SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    title: Text(
                      "PROFILE",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, "mentorprofile");
                    },
                    leading: Icon(Icons.person, color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    title: Text("POSTS", style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, "mentorpost");
                    },
                    leading: Icon(Icons.post_add, color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    title: Text("TASKS", style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pushNamed(context, "mentortask");
                    },
                    leading: Icon(Icons.work, color: Colors.white),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: ListTile(
                title: Text("SIGN OUT", style: TextStyle(color: Colors.white)),
                onTap: signOUt,
                leading: Icon(Icons.logout, color: Colors.white),
              ),
            ),
          ],
        ),
      ),

      body: FutureBuilder(
        future:
            FirebaseFirestore.instance.collection("userinfo").doc(userId).get(),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.blue));
          }
          if (!snapshots.hasData || !snapshots.data!.exists) {
            return Center(
              child: Text(
                "No data found",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          TextEditingController name = TextEditingController(
            text: "${snapshots.data!["name"]}",
          );

          TextEditingController about = TextEditingController();
          TextEditingController grad = TextEditingController();
          TextEditingController title = TextEditingController();

          Future<void> saveDetails() async {
            setState(() {
              _isLoading = true;
            });
            try {
              await FirebaseFirestore.instance
                  .collection("userinfo")
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .update({
                    "name": name.text.trim(),
                    "aboutMe": about.text.trim(),
                    "title": title.text.trim(),
                    "graduationYear": grad.text.trim(),
                  });

              // await FirebaseFirestore.instance
              //     .collection("userinfo")
              //     .doc(FirebaseAuth.instance.currentUser?.uid)
              //     .set({"level": level.text.trim(), "dept": dept.text.trim()});

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Details Successfully Saved!"),
                  backgroundColor: Colors.green,
                ),
              );
            } on FirebaseAuthException catch (e) {
              print(e.message);
            } finally {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
            }
          }

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    child: RandomAvatar("${snapshots.data!["imageUrl"]}"),
                  ),

                  SizedBox(height: 30),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Name", style: TextStyle(color: Colors.grey[200])),

                      SizedBox(height: 5),

                      TextField(
                        controller: name,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("About", style: TextStyle(color: Colors.grey[200])),

                      SizedBox(height: 5),

                      TextField(
                        controller: about,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Talk a little about yourself",
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Graduation Year",
                        style: TextStyle(color: Colors.grey[200]),
                      ),

                      SizedBox(height: 5),

                      TextField(
                        controller: grad,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "The year of graduation?",
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Title", style: TextStyle(color: Colors.grey[200])),

                      SizedBox(height: 5),

                      TextField(
                        controller: title,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Your Title?",
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 40),

                  Buttons(
                    text: _isLoading ? "Saving..." : "Save",
                    onTap: _isLoading ? null : saveDetails,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

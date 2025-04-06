import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/components/buttons.dart';

class MentorDashboardPage extends StatefulWidget {
  const MentorDashboardPage({super.key});

  @override
  State<MentorDashboardPage> createState() => _MentorDashboardPageState();
}

class _MentorDashboardPageState extends State<MentorDashboardPage> {
  void signOUt () {
    FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, "welcome");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Dashboard"),
      ),

      //drawer
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                DrawerHeader(child: Icon(Icons.person, size: 40, color: Colors.white,),),

                SizedBox(height: 20,),

                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(title: Text("HOME", style: TextStyle(color: Colors.white),), onTap: (){}, leading: Icon(Icons.home, color: Colors.white,),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(title: Text("HOME", style: TextStyle(color: Colors.white),), onTap: (){}, leading: Icon(Icons.home, color: Colors.white,),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(title: Text("HOME", style: TextStyle(color: Colors.white)), onTap: (){}, leading: Icon(Icons.home, color: Colors.white,),),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: ListTile(title: Text("SIGN OUT", style: TextStyle(color: Colors.white)), onTap: signOUt, leading: Icon(Icons.logout, color: Colors.white,),),
            ),
          ],
        ),
      ),
      
      body: Center(
        child: Buttons(text: "Logout", onTap: signOUt),
      ),
    );
  }
}

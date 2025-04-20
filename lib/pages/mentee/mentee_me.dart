import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled1/pages/mentee/mentee_profile.dart';

import '../login_page.dart';
import 'mentee_create_dart.dart';
import 'mentee_interests.dart';

class MenteeMe extends StatefulWidget{
  const MenteeMe({super.key});

  @override
  State<MenteeMe> createState() => _MenteeMeState();
  }

class _MenteeMeState extends State<MenteeMe> {

 /*Widget _selectedPage = const MenteeProfile();*/ // default view

  void _navigateTo(Widget page) {
    setState(() {
      /*_selectedPage = page;*/
      Navigator.pop(context); // Close drawer
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Color(0xFF687EFF),),

      drawer: Drawer(
        backgroundColor: Colors.grey[900],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: Text('Dashboard', style: GoogleFonts.tiroTamil(
                color: Color(0xFF687EFF),
                fontSize: 29,
              ),),
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.white), // Icon on the left
              title: Text(
                'Profile',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MenteeProfile()),
                );
              },


            ),


            ListTile(
              leading:  Icon(Icons.favorite_border, color: Colors.white),
              title:  Text('Interests', style: TextStyle(color: Colors.white, fontSize: 18),),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MenteeInterestsPage()),
                );
              },
            ),

            ListTile(
              leading: Icon(Icons.library_books, color: Colors.white),
              title: Text('Library', style: TextStyle(color: Colors.white, fontSize: 18),),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MenteeProfile()),
                );
              },
            ),

          ListTile(
            leading: Icon(Icons.edit_note, color: Colors.white),
            title: Text('Create', style: TextStyle(color: Colors.white, fontSize: 18),),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreatePostPage()),
              );
            },
          ),

            ListTile(
              leading: Icon(Icons.logout, color: Colors.white),
              title: Text('Log out', style: TextStyle(color: Colors.white, fontSize: 18),),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },

            ),

          ],
        ),
        ),



      body: const MenteeProfile(), // Default page content


    );
  }


}



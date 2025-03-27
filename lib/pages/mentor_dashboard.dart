import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:untitled1/pages/mentor/home_page.dart';
import 'package:untitled1/pages/mentor/mentor_dashboard_page.dart';

class MentorDashboard extends StatefulWidget {
  const MentorDashboard({super.key});


  @override
  State<MentorDashboard> createState() => _MentorDashboardState();
}

class _MentorDashboardState extends State<MentorDashboard> {
  int _selectedIndex = 0;

  final List _pages = [
    HomePage(),
    Center(child: Text("Explore", style: GoogleFonts.tiroTamil(color: Colors.white, fontSize: 40),),),
    Center(child: Text("Profile", style: GoogleFonts.tiroTamil(color: Colors.white, fontSize: 40),),),
    MentorDashboardPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(5.0),
        child: GNav(
          tabBorderRadius: 20,
            //tabBackgroundColor: Colors.grey.shade900,
            gap: 9,
            color: Colors.white,
            activeColor: Colors.blue,
            selectedIndex: _selectedIndex,
              padding: EdgeInsets.all(16),
              onTabChange: (index){
                setState(() {
                  _selectedIndex = index;
                });
              },
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: "Home",
                ),

                GButton(
                  icon: Icons.people,
                  text: "Search",
                ),

                GButton(
                  icon: Icons.explore,
                  text: "Explore",
                ),

                GButton(
                  icon: Icons.dashboard,
                  text: "Dashboard",
                ),
              ],
          ),
      ),
      body: _pages[_selectedIndex]
    );
  }
}

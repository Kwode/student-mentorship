import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:untitled1/components/connection.dart';
import 'package:untitled1/pages/mentor/mentor_network_page.dart';
import 'package:untitled1/pages/mentor/home_page.dart';
import 'package:untitled1/pages/mentor/mentor_dashboard_page.dart';

class MentorNavpage extends StatefulWidget {
  const MentorNavpage({super.key});

  @override
  State<MentorNavpage> createState() => _MentorNavpageState();
}

class _MentorNavpageState extends State<MentorNavpage> {
  int _selectedIndex = 0;

  final List _pages = [
    HomePage(),
    MentorNetworkPage(),
    Connections(),
    MentorDashboardPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20.0, left: 5, right: 5),
        child: GNav(
          tabBorderRadius: 20,
          //tabBackgroundColor: Colors.grey.shade900,
          gap: 9,
          color: Colors.white,
          activeColor: Colors.blue,
          selectedIndex: _selectedIndex,
          padding: EdgeInsets.all(16),
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          tabs: [
            GButton(icon: Icons.home, text: "Home"),

            GButton(icon: Icons.people, text: "Search"),

            GButton(icon: Icons.explore, text: "Explore"),

            GButton(icon: Icons.dashboard, text: "Dashboard"),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}

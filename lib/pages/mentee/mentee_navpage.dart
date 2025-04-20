import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:untitled1/pages/mentee/mentee_explore.dart';
import 'package:untitled1/pages/mentee/mentee_homepage.dart';
import 'package:untitled1/pages/mentee/mentee_me.dart';
import 'package:untitled1/pages/mentee/mentee_network_page.dart';

import '../../components/connection.dart';

class MenteeNavigation extends StatefulWidget {
  const MenteeNavigation({super.key});

  @override
  State<MenteeNavigation> createState() => _MenteeNavigationState();
}

class _MenteeNavigationState extends State<MenteeNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    MenteeHomepage(),
    MenteeNetworkPage(),
    Connections(),
    MenteeMe(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(25.0),
        child: GNav(
          tabBorderRadius: 20,
          tabBackgroundColor: Colors.grey.shade900,
          gap: 9,
          color: Colors.white,
          activeColor: Colors.blueAccent[700],
          selectedIndex: _selectedIndex,
          padding: const EdgeInsets.all(16),
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          tabs: const [
            GButton(icon: Icons.home, text: "Home"),
            GButton(icon: Icons.group, text: "Network"),
            GButton(icon: Icons.explore, text: "Explore"),
            GButton(icon: Icons.dashboard, text: "Dashboard"),
          ],
        ),
      ),
    );
  }
}

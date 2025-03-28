import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:untitled1/pages/mentee/mentee_dashboard_page.dart';

class MenteeDashboard extends StatefulWidget {
  MenteeDashboard({super.key});

  @override
  State<MenteeDashboard> createState() => _MenteeDashboardState();
}

class _MenteeDashboardState extends State<MenteeDashboard> {
  int _selectedIndex = 0;

  final List _pages = [
    Center(child: Text("Mentee Dashboard", style: GoogleFonts.tiroTamil(color: Colors.white, fontSize: 40),),),
    Center(child: Text("Profile", style: GoogleFonts.tiroTamil(color: Colors.white, fontSize: 40),),),
    Center(child: Text("Profile", style: GoogleFonts.tiroTamil(color: Colors.white, fontSize: 40),),),
    MenteeDashboardPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(15.0),
          child: GNav(
            tabBorderRadius: 20,
            tabBackgroundColor: Colors.grey.shade900,
            gap: 9,
            color: Colors.purple,
            activeColor: Colors.purple,
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
                icon: Icons.explore,
                text: "Explore",
              ),

              GButton(
                icon: Icons.person,
                text: "Profile",
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

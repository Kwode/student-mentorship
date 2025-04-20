import 'package:flutter/material.dart';
import 'package:untitled1/pages/mentee/mentee_explore.dart';
import '../pages/mentee/connection_requests.dart';

class Connections extends StatefulWidget {
  const Connections({super.key});
  /// This is used in the explore page to navigate between recommended and requests
  @override
  State<Connections> createState() => _ConnectionSelection();
}

class _ConnectionSelection extends State<Connections> {
  // List of categories
  final List<String> categories = [
    "Recommended", "Requests"
  ];

  // Default selected category
  String selectedCategory = "Recommended";

  // Index for selecting which page to display
  int _selectedIndex = 0;

  final List<Widget> _tabs = [
    ExplorePage(),
    RequestPage(),
    // You can add more pages here for each category later if needed.
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              Container(
                height: 40,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[800],
                ),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Search...",
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: Colors.white),
                  ),
                ),
              ),

              SizedBox(height: 20), // Space between search bar and categories

              // Horizontal categories row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: categories.map((category) {
                    bool isSelected = category == selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory = category; // Update selected category
                            _selectedIndex = categories.indexOf(category); // Update selected index
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? Color(0xFF80B3FF) : Colors.grey[900],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              color: isSelected ? Colors.black : Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              SizedBox(height: 30), // Space between categories and page content


              Expanded(
                child: _tabs[_selectedIndex],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

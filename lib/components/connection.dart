import 'package:flutter/material.dart';
import 'package:untitled1/pages/mentee/mentee_connected.dart';
import 'package:untitled1/pages/mentee/mentee_explore.dart';
import '../pages/mentee/connection_requests.dart';

class Connections extends StatefulWidget {
  const Connections({super.key});

  @override
  State<Connections> createState() => _ConnectionSelection();
}

class _ConnectionSelection extends State<Connections> {
  final List<String> categories = ["Recommended", "Requests", "Connected"];
  String selectedCategory = "Recommended";
  int _selectedIndex = 0;
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final List<Widget> _tabs = [
      ExplorePage(searchQuery: _searchQuery),
      RequestPage(),
      Connected(),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextField(
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  hintText: "Search",
                  hintStyle: const TextStyle(color: Colors.white70),
                  suffixIcon: const Icon(Icons.search, color: Colors.white),
                ),
              ),

              const SizedBox(height: 20),

              // Categories
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      categories.map((category) {
                        bool isSelected = category == selectedCategory;
                        return Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCategory = category;
                                _selectedIndex = categories.indexOf(category);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isSelected ? Color(0xFF687EFF) : Colors.grey[900],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                category,
                                style: const TextStyle(
                                  color: Colors.white,
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

              const SizedBox(height: 30),

              Expanded(child: _tabs[_selectedIndex]),
            ],
          ),
        ),
      ),
    );
  }
}

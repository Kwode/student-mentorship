import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/components/buttons.dart';

class PreferencesPage extends StatefulWidget {
  final String userCategory;

  const PreferencesPage({super.key, required this.userCategory});

  @override
  _PreferencesPageState createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {

  List<String> selectedPreferences = [];


  final ScrollController _scrollController = ScrollController();
  bool _showScrollbar = false;

  String? uid = FirebaseAuth.instance.currentUser!.uid;

  void navToBsignUp() async{
    try {
      await FirebaseFirestore.instance.collection("userinfo").doc(uid).update({
        "preferences": selectedPreferences
      });
    }catch (e) {
      print(e);
    }
    print(selectedPreferences);

    Navigator.pushNamed(context, "profile");
  }


  void toggleSelection(String preference) {
    setState(() {
      if (selectedPreferences.contains(preference)) {
        selectedPreferences.remove(preference);
      } else {
        selectedPreferences.add(preference);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _showScrollbar = true;
      });

      // Hide scrollbar after 3 seconds of inactivity
      Future.delayed(Duration(seconds: 3), () {
        if (!_scrollController.position.isScrollingNotifier.value) {
          setState(() {
            _showScrollbar = false;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _showScrollbar = true;
    });

    // Hide scrollbar after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _showScrollbar = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    List<String> options = widget.userCategory == "Mentor"
        ? ["Business", "Tech", "Entrepreneurship", "Marketing", "Design", "Finance"]
        : ["Business", "Tech", "Entrepreneurship", "Marketing", "Design", "Finance"];

    Map<String, String> images = {
      "Business": "lib/images/Business.jpg",
      "Tech": "lib/images/Code.jpg",
      "Entrepreneurship": "lib/images/Reading.jpg",
      "Design": "lib/images/Music.jpg",
      "Marketing": "lib/images/Food.jpg",
      "Finance": "lib/images/Trading.jpg",
    };

    return Scaffold(
      appBar: AppBar(
        title: Text("Select Your Interests"),
      ),
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _handleTap,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Select the topics you're interested in:",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: _showScrollbar,
                thickness: 6.0,
                radius: Radius.circular(10),
                child: ListView(
                  controller: _scrollController,
                  children: options.map((option) {
                    bool isSelected = selectedPreferences.contains(option);
                    return GestureDetector(
                      onTap: () => toggleSelection(option),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: isSelected ? Colors.blueAccent : Colors.transparent, width: 2),
                          image: DecorationImage(
                            image: AssetImage(images[option] ?? "assets/images/default.jpg"),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken)
                          ),
                        ),
                        height: 120,
                        alignment: Alignment.center,
                        child: Text(
                          option,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 5,
                                color: Colors.black54,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Buttons(
                text: "Continue",
                onTap: (){
                  if(selectedPreferences.isEmpty){
                    showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return AlertDialog(
                            title: Text("Choose A Topic", textAlign: TextAlign.center,),
                            actions: [
                              TextButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                  },
                                  child: Text("OK"),
                              ),
                            ],
                          );
                        }
                    );
                  }else if(selectedPreferences.length < 3){
                    print("less than 3");
                    showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return AlertDialog(
                            title: Text("Choose At Least 3 Topics"),
                            actions: [
                              TextButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                  },
                                  child: Text("OK")
                              ),
                            ],
                          );
                        }
                    );
                  }else{
                    navToBsignUp();
                  }
                }
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

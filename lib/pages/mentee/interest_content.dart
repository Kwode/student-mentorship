import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/components/progress_bar.dart';
import 'package:untitled1/models/chat_service.dart';
import 'package:untitled1/pages/mentee/goals_to_mentor.dart';
import 'package:confetti/confetti.dart'; // Add confetti package

class InterestDetailPage extends StatefulWidget {
  final String interest;

  const InterestDetailPage({super.key, required this.interest});

  @override
  State<InterestDetailPage> createState() => _InterestDetailPageState();
}

class _InterestDetailPageState extends State<InterestDetailPage> {
  Map<String, List<Map<String, dynamic>>> goalsWithMilestones = {};
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: Duration(seconds: 2));
    _loadGoalsFromFirestore();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  // Load goals from Firestore
  Future<void> _loadGoalsFromFirestore() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("userinfo")
          .doc(uid)
          .collection("interests")
          .doc(widget.interest)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final Map<String, List<Map<String, dynamic>>> loadedGoals = {};
        data.forEach((key, value) {
          loadedGoals[key] = List<Map<String, dynamic>>.from(value.map((item) {
            return Map<String, dynamic>.from(item);
          }));
        });

        setState(() {
          goalsWithMilestones = loadedGoals;
        });
      }
    } catch (e) {
      print("Error loading goals: $e");
    }
  }

  // Save goals with milestones to Firestore
  Future<void> _saveGoalsToFirestore() async {
    try {
      await FirebaseFirestore.instance
          .collection("userinfo")
          .doc(uid)
          .collection("interests")
          .doc(widget.interest)
          .set(goalsWithMilestones);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Saved successfully!")),
      );
    } catch (e) {
      print("Error saving goals: $e");
    }
  }

  String? _getBadgeImage(String badgeName) {
    switch (badgeName) {
      case "Rising Star ⭐":
        return "assets/badges/rising_star.png";
      case "Achiever 🏆":
        return "assets/badges/achiever.png";
      case "Master 🥇":
        return "assets/badges/master.png";
      default:
        return null;
    }
  }

  Future<void> _checkAndAwardBadge() async {
    int completedGoals = 0;

    goalsWithMilestones.forEach((goal, milestones) {
      if (milestones.isNotEmpty && milestones.every((m) => m['done'] == true)) {
        completedGoals++;
      }
    });

    final userDoc = await FirebaseFirestore.instance.collection('userinfo').doc(uid).get();
    final existingBadges = (userDoc.data()?['badges'] ?? []) as List<dynamic>;

    Map<int, String> badgesToAward = {
      3: "Rising Star ⭐",
      5: "Achiever 🏆",
      10: "Master 🥇",
    };

    for (var entry in badgesToAward.entries) {
      if (completedGoals >= entry.key && !existingBadges.contains(entry.value)) {
        existingBadges.add(entry.value);

        await FirebaseFirestore.instance.collection('userinfo').doc(uid).update({
          'badges': existingBadges,
        });

        _confettiController.play();

        String? badgeImage = _getBadgeImage(entry.value);

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Column(
              children: [
                if (badgeImage != null)
                  Image.asset(
                    badgeImage,
                    width: 80,
                    height: 80,
                  ),
                SizedBox(height: 10),
                Text(
                  'Congratulations!',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: Text('You have earned the "${entry.value}" badge! 🎉'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Awesome!'),
              ),
            ],
          ),
        );
      }
    }
  }

  void _showAddGoalDialog(BuildContext context) {
    final TextEditingController _goalController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Goal for ${widget.interest}'),
        content: TextField(
          controller: _goalController,
          decoration: InputDecoration(hintText: 'Enter your goal...'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newGoal = _goalController.text.trim();
              if (newGoal.isNotEmpty) {
                setState(() {
                  goalsWithMilestones[newGoal] = [];
                });
                _saveGoalsToFirestore();
                _checkAndAwardBadge();
                Navigator.of(context).pop();
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddMilestoneDialog(String goal) {
    final TextEditingController _milestoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Milestone to "$goal"'),
        content: TextField(
          controller: _milestoneController,
          decoration: InputDecoration(hintText: 'Enter your milestone...'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newMilestone = _milestoneController.text.trim();
              if (newMilestone.isNotEmpty) {
                setState(() {
                  goalsWithMilestones[goal]?.add({
                    'milestone': newMilestone,
                    'done': false,
                  });
                });
                _saveGoalsToFirestore();
                Navigator.of(context).pop();
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _toggleMilestoneStatus(String goal, String milestone) {
    setState(() {
      final milestoneIndex = goalsWithMilestones[goal]!
          .indexWhere((item) => item['milestone'] == milestone);
      if (milestoneIndex != -1) {
        goalsWithMilestones[goal]![milestoneIndex]['done'] =
        !goalsWithMilestones[goal]![milestoneIndex]['done'];
      }
    });
    _saveGoalsToFirestore();
    _checkAndAwardBadge();
  }

  void _showEditMilestoneDialog(String goal, String oldMilestone) {
    final TextEditingController _milestoneController = TextEditingController();
    _milestoneController.text = oldMilestone;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Milestone for "$goal"'),
        content: TextField(
          controller: _milestoneController,
          decoration: InputDecoration(hintText: 'Edit your milestone...'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final updatedMilestone = _milestoneController.text.trim();
              if (updatedMilestone.isNotEmpty) {
                setState(() {
                  final milestoneIndex = goalsWithMilestones[goal]!
                      .indexWhere((item) => item['milestone'] == oldMilestone);
                  if (milestoneIndex != -1) {
                    goalsWithMilestones[goal]![milestoneIndex]['milestone'] =
                        updatedMilestone;
                  }
                });
                _saveGoalsToFirestore();
                Navigator.of(context).pop();
              }
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteGoal(String goal) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Delete Goal"),
        content: Text("Are you sure you want to delete \"$goal\"?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                goalsWithMilestones.remove(goal);
              });
              _saveGoalsToFirestore();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }

  void _sendMilestonesToMentor() async {
    final selectedMentorId = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectMentorForMilestone(),
      ),
    );

    if (selectedMentorId != null) {
      await _uploadMilestones(selectedMentorId);

      // Send the goals as a chat message
      await ChatService().sendGoalsMessage(selectedMentorId, goalsWithMilestones);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Milestones sent to mentor and shared in chat!")),
      );
    }
  }


  Future<void> _uploadMilestones(String mentorId) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    for (var entry in goalsWithMilestones.entries) {
      final goal = entry.key;
      final milestones = entry.value;

      for (var milestone in milestones) {
        await FirebaseFirestore.instance.collection('milestones').add({
          'from': currentUserId,
          'to': mentorId,
          'goal': goal,
          'milestone': milestone['milestone'],
          'done': milestone['done'],
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Milestones sent to mentor!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color(0xFF687EFF),
        title: Text('Goals in ${widget.interest}'),
        actions: [
          IconButton(
            onPressed: _sendMilestonesToMentor,
            icon: Icon(Icons.send),
            tooltip: "Send Milestones to Mentor",
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your Progress",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                GoalProgressWidget(userId: uid),
                SizedBox(height: 30),
                Text(
                  "Your Goals",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView(
                    children: goalsWithMilestones.entries.map((entry) {
                      final goal = entry.key;
                      final milestones = entry.value;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Goal: $goal',
                                  style: TextStyle(
                                    color: Color(0xFF687EFF),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.add, color: Colors.white),
                                    onPressed: () => _showAddMilestoneDialog(goal),
                                    tooltip: "Add Milestone",
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.redAccent),
                                    onPressed: () => _confirmDeleteGoal(goal),
                                    tooltip: "Delete Goal",
                                  ),
                                ],
                              ),
                            ],
                          ),
                          ...milestones.map((milestone) {
                            return ListTile(
                              contentPadding: EdgeInsets.only(left: 16.0),
                              title: Text(
                                milestone['milestone'],
                                style: TextStyle(
                                  color: milestone['done'] ? Color(0xFF687EFF) : Colors.white,
                                  decoration: milestone['done']
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.edit, color: Colors.white),
                                onPressed: () => _showEditMilestoneDialog(goal, milestone['milestone']),
                              ),
                              onTap: () => _toggleMilestoneStatus(goal, milestone['milestone']),
                            );
                          }).toList(),
                          SizedBox(height: 20),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: [Colors.blue, Colors.purple, Colors.white],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddGoalDialog(context),
        backgroundColor: Color(0xFF687EFF),
        tooltip: "Add Goal",
        child: Icon(Icons.add),
      ),
    );
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/pages/mentee/goals_to_mentor.dart';

class InterestDetailPage extends StatefulWidget {
  final String interest;

  const InterestDetailPage({super.key, required this.interest});

  @override
  State<InterestDetailPage> createState() => _InterestDetailPageState();
}

class _InterestDetailPageState extends State<InterestDetailPage> {
  Map<String, List<Map<String, dynamic>>> goalsWithMilestones = {}; // Add "done" status for milestones
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _loadGoalsFromFirestore();
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
    } catch (e) {
      print("Error saving goals: $e");
    }
  }

  // Show dialog to add a goal
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
                Navigator.of(context).pop();
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  // Show dialog to add milestone
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

  // Mark milestone as done
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
  }

  // Edit a milestone
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

  // Delete goal
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

  // Send milestones to mentor
  void _sendMilestonesToMentor() async {
    final selectedMentorId = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectMentorForMilestone(), // I'll show this widget below
      ),
    );

    if (selectedMentorId != null) {
      _uploadMilestones(selectedMentorId);
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
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
                        'Goal: ${goal}',
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
                          tooltip: "Add Milestone",
                          onPressed: () => _showAddMilestoneDialog(goal),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.redAccent),
                          tooltip: "Delete Goal",
                          onPressed: () => _confirmDeleteGoal(goal),
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
                      icon: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      onPressed: () => _showEditMilestoneDialog(
                          goal, milestone['milestone']),
                    ),
                    onTap: () => _toggleMilestoneStatus(
                        goal, milestone['milestone']),
                  );
                }).toList(),
                SizedBox(height: 20),
              ],
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddGoalDialog(context),
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF687EFF),
        tooltip: "Add Goal",
      ),
    );
  }
}

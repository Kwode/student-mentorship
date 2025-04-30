import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// ---
/// Service: Handles real-time fetching of user's goals progress from Firestore
/// ---
class GoalProgressService {
  static Stream<Map<String, int>> goalProgressStream(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('goals')
        .snapshots()
        .map((snapshot) {
      int totalGoals = snapshot.docs.length;
      int completedGoals = snapshot.docs.where((doc) => doc['completed'] == true).length;

      return {
        'totalGoals': totalGoals,
        'completedGoals': completedGoals,
      };
    });
  }
}

/// ---
/// Widget: Displays a linear progress bar based on completed vs total goals
/// ---
class GoalProgressBar extends StatelessWidget {
  final int completedGoals;
  final int totalGoals;

  const GoalProgressBar({
    Key? key,
    required this.completedGoals,
    required this.totalGoals,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double progress = totalGoals == 0 ? 0 : completedGoals / totalGoals;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Goals Completed: $completedGoals / $totalGoals',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(10), // 👈 set the roundness here
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF80B3FF)),
            minHeight: 20,
          ),
        ),

      ],
    );
  }
}

/// ---
/// Widget: Listens to Firestore in real-time and builds GoalProgressBar
/// ---
class GoalProgressWidget extends StatelessWidget {
  final String userId;

  const GoalProgressWidget({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, int>>(
      stream: GoalProgressService.goalProgressStream(userId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!;
        final totalGoals = data['totalGoals']!;
        final completedGoals = data['completedGoals']!;

        return GoalProgressBar(
          completedGoals: completedGoals,
          totalGoals: totalGoals,
        );
      },
    );
  }
}

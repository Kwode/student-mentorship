import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CurrentBadgeWidget extends StatefulWidget {
  final double size;

  const CurrentBadgeWidget({Key? key, this.size = 100.0}) : super(key: key);

  @override
  State<CurrentBadgeWidget> createState() => _CurrentBadgeWidgetState();
}

class _CurrentBadgeWidgetState extends State<CurrentBadgeWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String? _currentBadge;

  final Map<String, String> badgeImages = {
    'Rising Star ⭐': 'assets/badges/rising_star.png',
    'Achiever 🏆': 'assets/badges/achiever.png',
    'Master 🥇': 'assets/badges/master.png',
  };

  final Map<String, Color> badgeGlowColors = {
    'Rising Star ⭐': Colors.blueAccent,
    'Achiever 🏆': Colors.deepPurpleAccent,
    'Master 🥇': Colors.amber,
  };

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _fetchCurrentBadge();
  }

  void _initAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  Future<void> _fetchCurrentBadge() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final userDoc = await FirebaseFirestore.instance.collection('userinfo').doc(uid).get();
    final badges = (userDoc.data()?['badges'] ?? []) as List<dynamic>;

    if (badges.isNotEmpty) {
      setState(() {
        _currentBadge = badges.last as String;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentBadge == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.star_border_outlined, color: Colors.grey, size: 30.0)
          ,
          const SizedBox(height: 8),
          const Text(
            "No badges yet!",
            style: TextStyle(color: Colors.grey,  fontSize: 16.0),
          ),
        ],
      );
    }

    final badgeImagePath = badgeImages[_currentBadge!];
    final glowColor = badgeGlowColors[_currentBadge!] ?? Colors.amber;

    if (badgeImagePath == null) {
      return const Text(
        "Unknown badge",
        style: TextStyle(color: Colors.red),
      );
    }

    return ScaleTransition(
      scale: _animation,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: glowColor.withOpacity(0.6),
              blurRadius: 18,
              spreadRadius: 6,
            ),
          ],
        ),
        child: ClipOval(
          child: Image.asset(
            badgeImagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

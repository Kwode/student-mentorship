import 'package:flutter/material.dart';

class Pfp extends StatelessWidget {
  const Pfp({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 70,
          left: 6,
          child: CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('lib/images/avatar1.jpeg'), // Add your image
          ),
        ),
        Positioned(
          top: 0,
          left: 70,
          child: CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('lib/images/avatar2.jpg'),
          ),
        ),
        Positioned(
          top: 90,
          left: 105,
          child: CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('lib/images/avatar6.jpeg'),
          ),
        ),
        Positioned(
          top: 170,
          left: 50,
          child: CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('lib/images/avatar3.jpg'),
          ),
        ),
        Positioned(
          top: 10,
          left: 170,
          child: CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('lib/images/avatar5.jpg'),
          ),
        ),Positioned(
          top: 150,
          left: -50,
          child: CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('lib/images/avatar7.jpg'),
          ),
        ),
      ],
    );
  }
}

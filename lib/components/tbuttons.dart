import 'package:flutter/material.dart';

class Tbuttons extends StatelessWidget {
  const Tbuttons({super.key, required this.text, required this.onTap});

  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        textAlign: TextAlign.end,
        text,
        style: TextStyle(
          color: Colors.blue[500],
        ),
      ),
    );
  }
}

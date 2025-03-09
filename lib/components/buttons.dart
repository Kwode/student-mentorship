import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Buttons extends StatelessWidget {
  const Buttons({super.key, required this.text, required this.onTap});

  final String text;
  final void Function()? onTap;


  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue[500], // Button color
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10), // Ensures ripple effect follows shape
        child: Container(
          height: 50,
          width: 200,
          alignment: Alignment.center,
          child: Text(
            text,
            style: GoogleFonts.abel(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled1/components/buttons.dart';

class BsignUp extends StatelessWidget {
  const BsignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "I am a...",
              style: GoogleFonts.tiroTamil(
                color: Colors.white,
                fontSize: 40
              ),
            ),

            SizedBox(height: 50,),

            Buttons(text: "Mentor", onTap: (){}),

            SizedBox(height: 20,),

            Buttons(text: "Mentee", onTap: (){}),
          ],
        ),
      ),
    );
  }
}

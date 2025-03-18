import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled1/components/buttons.dart';

import '../components/pfp.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {

    void navToLogin(){
      Navigator.pushNamed(context, "signin");
    }
    void navToSignUp(){
      Navigator.pushNamed(context, "bsign");
    }

    return Scaffold(
        backgroundColor: Colors.black,

        //design for the welcome page
        body: Column(
          children: [
            SizedBox(height: 20,),

            //pictures at the top
            Expanded(
                child: Pfp()
            ),

            //text
            Expanded(
              child: Column(
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    "Where Connection Fuels Success.",
                    style: GoogleFonts.tiroTamil(
                      color: Colors.white,
                      fontSize: 39,
                    ),
                  ),

                  SizedBox(height: 60,),

                  //get started button
                  Buttons(text: "Get Started", onTap: navToSignUp),

                  SizedBox(height: 8,),

                  //key to login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already a member?",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(width: 5,),

                      //sign in text
                      GestureDetector(
                        onTap: navToLogin,
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                            color: Colors.blue[500],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        )
    );
  }
}

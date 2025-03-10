import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled1/components/buttons.dart';
import 'package:untitled1/components/pfp.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  void navToLogin(){
    Navigator.pushNamed(context, "bsign");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20,),

        Expanded(
            child: Pfp()
        ),

        SizedBox(height: 20,),

        //text
        Expanded(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  textAlign: TextAlign.center,
                  "Where Connection Fuels Success.",
                    style: GoogleFonts.tiroTamil(
                      color: Colors.white,
                      fontSize: 38,
                  ),
                ),
              ),

              SizedBox(height: 60,),

              Buttons(text: "Get Started", onTap: navToLogin),

              SizedBox(height: 20,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already a member?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),

                  SizedBox(width: 10,),

                  GestureDetector(
                    onTap: navToLogin,
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        color: Colors.blue[500],
                        fontSize: 15,
                      ),
                    ),
                  )
                ],
              )

            ],
          ),
          ),

      ],
    );
  }
}

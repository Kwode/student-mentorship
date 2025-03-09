import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled1/components/buttons.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  void navToSignIn(){
    Navigator.pushNamed(context, "signin");
  }
  void navToBsign(){
    Navigator.pushNamed(context, "bsign");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              SizedBox(height: 70,),
              //text
              Text(
                  textAlign: TextAlign.center,
                  "Sign Up",
                  style: GoogleFonts.tiroTamil(
                    color: Colors.white,
                    fontSize: 40,
                  )
              ),

              SizedBox(height: 50,),

              //text fields
              TextField(
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2), //Default border color
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2), //Border color when focused
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Enter Full Name",
                    hintStyle: TextStyle(
                      color: Colors.white,
                    )
                ),
              ),

              SizedBox(height: 40,),

              TextField(
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2), //Default border color
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2), //Border color when focused
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Enter Email",
                    hintStyle: TextStyle(
                      color: Colors.white,
                    )
                ),
              ),

              SizedBox(height: 40,),

              TextField(
                style: TextStyle(
                  color: Colors.white,
                ),
                obscureText: true,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2), //Default border color
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2), //Border color when focused
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Enter Password",
                    hintStyle: TextStyle(
                      color: Colors.white,
                    )
                ),
              ),

              SizedBox(height: 40,),

              TextField(
                style: TextStyle(
                  color: Colors.white,
                ),
                obscureText: true,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2), //Default border color
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2), //Border color when focused
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Confirm Password",
                    hintStyle: TextStyle(
                      color: Colors.white,
                    )
                ),
              ),

              SizedBox(height: 40,),

              //sign up button
              Buttons(text: "Sign Up", onTap: navToBsign),

              SizedBox(height: 20,),

              //"or divider"
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey, // Line color
                      thickness: 1,       // Line thickness
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "or",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 40,),

              //sign in with google
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(10), // Ensures ripple effect follows shape
                child: Ink(
                  decoration: BoxDecoration(
                    color: Colors.transparent, // Keep background transparent
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.blue,  // Border color
                      width: 2,           // Border width
                    ),
                  ),
                  child: Container(
                    height: 50,
                    width: 250, // Increased width to fit text
                    padding: EdgeInsets.symmetric(horizontal: 10), // Add padding inside
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "lib/images/google.jpg",
                          height: 35,
                          width: 35,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Continue with Google",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20,),

              //Already a member?
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

                  SizedBox(width: 6,),

                  GestureDetector(
                    onTap: navToSignIn,
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
      ),
    );
  }
}

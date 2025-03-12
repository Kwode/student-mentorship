import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:untitled1/components/buttons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void navToSignUp(){
    Navigator.pushNamed(context, "bsign");
  }

  Future<UserCredential?> signInWithGoogle() async{
    //begin google sign in process
    final GoogleSignInAccount? gUser =  await GoogleSignIn().signIn();


    //when user cancels
    if(gUser == null) {
      return null;
    }

    //obtain auth details from request
    final GoogleSignInAuthentication gAuth = await gUser.authentication;

    //create credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken
    );

    //sign in user
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  void signIn() async{

    showDialog(
      context: context,
      builder: (context) {
        return Center(
            child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email.text.trim(),
          password: _password.text.trim()
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
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
              SizedBox(height: 110,),
              // sign in text
              Text(
                textAlign: TextAlign.center,
                  "Sign In",
                  style: GoogleFonts.tiroTamil(
                    color: Colors.white,
                    fontSize: 40,
                  )
              ),

              SizedBox(height: 50,),

              //email
              TextField(
                controller: _email,
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

              //password
              TextField(
                controller: _password,
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

              SizedBox(height: 20,),

              //forgot password
              GestureDetector(
                onTap: (){},
                child: Text(
                  textAlign: TextAlign.right,
                  "Forgot Password?",
                  style: TextStyle(
                    color: Colors.blue[500],
                    fontSize: 15
                  ),
                ),
              ),

              SizedBox(height: 40,),

              //sign in button
              Buttons(text: "Sign In", onTap: signIn),

              SizedBox(height: 40,),


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
                onTap: signInWithGoogle,
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

              //not yet registered?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not registered yet?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),

                  SizedBox(width: 6,),

                  GestureDetector(
                    onTap: navToSignUp,
                    child: Text(
                      "Sign Up",
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

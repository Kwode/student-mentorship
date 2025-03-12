import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled1/components/buttons.dart';
import 'package:untitled1/pages/preferences_page.dart';

class BsignUp extends StatefulWidget {
  const BsignUp({super.key});

  @override
  State<BsignUp> createState() => _BsignUpState();
}

class _BsignUpState extends State<BsignUp> {
  final _formKey = GlobalKey<FormState>();


  //controllers for text fields
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final TextEditingController _dob = TextEditingController();
  DateTime? _selectedDate;

  String _selectedGender = "Male";
  String _selectedCategory = "Mentee"; //Default form selection


  @override
  void dispose(){
    _fullName.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }


  Future<void> _submitForm() async{
    if(_formKey.currentState!.validate()){
      try {
        final userCred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email.text.trim(),
          password: _password.text.trim(),
        );

        await FirebaseFirestore.instance.collection("userinfo").add({
          "name": _fullName.text.trim(),
          "email": _email.text.trim(),
          "date of birth": _dob.text.trim(),
          "pass": _password.text.trim(),
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PreferencesPage(userCategory: _selectedCategory)),
        );
      } on FirebaseAuthException catch (e) {
        print(e.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
              SizedBox(height: 70,),

            Text(
              "Sign Up",
              textAlign: TextAlign.center,
              style: GoogleFonts.tiroTamil(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 50,),

            Form(
              key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    //Full Name
                    TextFormField(
                      style: TextStyle(
                        color: Colors.white
                      ),
                      controller: _fullName,
                      decoration: InputDecoration(
                        labelText: "First Name",
                        labelStyle: TextStyle(
                          color: Colors.white
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "Please enter your full name";
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 30,),

                    //Email
                    TextFormField(
                      style: TextStyle(
                        color: Colors.white
                      ),
                      controller: _email,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(color: Colors.white),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.green, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      // validator: (value){
                      //   if(value == null || value.isEmpty){
                      //     return "Please enter your email";
                      //   } else if(!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z{2,4}]$').hasMatch(value)){
                      //     return "Enter a valid email address";
                      //   }
                      //   return null;
                      // },
                    ),

                    SizedBox(height: 30,),

                    //password
                    TextFormField(
                      style: TextStyle(
                        color: Colors.white
                      ),
                      obscureText: true,
                      controller: _password,
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.white),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.green, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                      ),
                      validator: (value){
                        if(value == null || value.length < 2){
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 30,),

                    //confirm password
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      obscureText: true,
                      controller: _confirmPassword,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        labelStyle: TextStyle(color: Colors.white),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.green, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                      ),
                      validator: (value){
                        if(value == null || _password.text != _confirmPassword.text){
                          return "Password does not match";
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 30,),

                    //Gender selector
                    DropdownButtonFormField<String>(
                        style: TextStyle(color: Colors.white),
                        value: _selectedGender,
                        decoration: InputDecoration(
                          labelText: "Select Gender",
                          labelStyle: TextStyle(color: Colors.white),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blue, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.green, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                        ),
                        dropdownColor: Colors.black,
                        icon: Icon(Icons.arrow_drop_down_circle_outlined),
                        items: ["Male", "Female", "Others"].map((category){
                          return DropdownMenuItem(value: category, child: Text(category));
                        }).toList(),
                        onChanged: (value){
                          setState(() {
                            _selectedGender = value!;
                          });
                        }
                    ),

                    SizedBox(height: 30,),


                    //Dropdown to select mentor or mentee
                    DropdownButtonFormField<String>(
                      style: TextStyle(color: Colors.white),
                      value: _selectedCategory,
                        decoration: InputDecoration(
                          labelText: "Sign Up As",
                          labelStyle: TextStyle(color: Colors.white),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blue, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.green, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                        ),
                        dropdownColor: Colors.black,
                        icon: Icon(Icons.arrow_drop_down_circle_outlined),
                        items: ["Mentor", "Mentee"].map((category){
                          return DropdownMenuItem(value: category,child: Text(category));
                        }).toList(),
                        onChanged: (value){
                          setState(() {
                            _selectedCategory = value!;
                          });
                        }
                    ),

                    SizedBox(height: 30,),

                    //Date of Birth
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      readOnly: true,
                      onTap: () async{
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1960),
                            lastDate: DateTime.now()
                        );

                        if (pickedDate != null){
                          setState(() {
                            _selectedDate = pickedDate;
                            _dob.text = "${pickedDate.year}/${pickedDate.month}/${pickedDate.day}";
                          });
                        }
                      },
                      controller: _dob,
                      decoration: InputDecoration(
                        labelText: "Date Of Birth",
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                          focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                          focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                          errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                        suffixIcon: Icon(Icons.calendar_month_outlined)
                      ),

                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "Please Select Date of Birth";
                        }
                        return null;
                      },
                    ),

                    //mentor-specific fields
                    // if(_selectedCategory == "Mentor")...[
                    //   SizedBox(height: 40,),
                    //   TextFormField(
                    //     style: TextStyle(
                    //         color: Colors.white
                    //     ),
                    //     controller: _fullName,
                    //     decoration: InputDecoration(
                    //       labelText: "Enter Area of Expertise",
                    //       labelStyle: TextStyle(
                    //           color: Colors.white
                    //       ),
                    //       enabledBorder: OutlineInputBorder(
                    //         borderSide: BorderSide(color: Colors.blue, width: 2),
                    //         borderRadius: BorderRadius.circular(10),
                    //       ),
                    //       focusedBorder: OutlineInputBorder(
                    //           borderSide: BorderSide(color: Colors.green),
                    //           borderRadius: BorderRadius.circular(10)
                    //       ),
                    //       errorBorder: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(10),
                    //         borderSide: BorderSide(color: Colors.red, width: 2),
                    //       ),
                    //       focusedErrorBorder: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(10),
                    //         borderSide: BorderSide(color: Colors.red, width: 2),
                    //       ),
                    //     ),
                    //     validator: (value){
                    //       if(value == null || value.isEmpty){
                    //         return "Please enter your full name";
                    //       }
                    //       return null;
                    //     },
                    //   ),
                    //
                    // ],
                    //
                    // if(_selectedCategory == "Mentee")...[
                    //   SizedBox(height: 40,),
                    //   TextFormField(
                    //     style: TextStyle(
                    //         color: Colors.white
                    //     ),
                    //     controller: _fullName,
                    //     decoration: InputDecoration(
                    //       labelText: "Enter Area of Interest",
                    //       labelStyle: TextStyle(
                    //           color: Colors.white
                    //       ),
                    //       enabledBorder: OutlineInputBorder(
                    //         borderSide: BorderSide(color: Colors.blue, width: 2),
                    //         borderRadius: BorderRadius.circular(10),
                    //       ),
                    //       focusedBorder: OutlineInputBorder(
                    //           borderSide: BorderSide(color: Colors.green),
                    //           borderRadius: BorderRadius.circular(10)
                    //       ),
                    //       errorBorder: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(10),
                    //         borderSide: BorderSide(color: Colors.red, width: 2),
                    //       ),
                    //       focusedErrorBorder: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(10),
                    //         borderSide: BorderSide(color: Colors.red, width: 2),
                    //       ),
                    //     ),
                    //     validator: (value){
                    //       if(value == null || value.isEmpty){
                    //         return "Please enter your full name";
                    //       }
                    //       return null;
                    //     },
                    //   ),
                    //
                    // ],

                    SizedBox(height: 40,),

                    Buttons(text: "Next", onTap: () async
                    {
                      _submitForm();
                    }),
                  ],
                )
            ),
          ],
          ),
        ),
      ),
    );
  }
}

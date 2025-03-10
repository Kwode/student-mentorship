import 'package:flutter/material.dart';
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

  void _submitForm(){
    if(_formKey.currentState!.validate()){
      print("Name:  ${_fullName.text}");
      print("Name:  ${_email.text}");
      print("Name:  ${_password.text}");
      print("Name:  $_selectedCategory");

      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PreferencesPage(userCategory: _selectedCategory)),
      );
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
              SizedBox(height: 100,),

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

                    SizedBox(height: 40,),

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

                    SizedBox(height: 40,),

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
                        if(value == null || value.length < 5){
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 40,),

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

                    SizedBox(height: 40,),

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

                    SizedBox(height: 40,),


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

                    SizedBox(height: 40,),

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

                    Buttons(text: "Next", onTap: _submitForm),
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

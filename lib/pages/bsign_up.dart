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
  bool _isObscured = true;

  //controllers for text fields
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  // final TextEditingController _level = TextEditingController();
  // final TextEditingController _dept = TextEditingController();
  final TextEditingController _dob = TextEditingController();
  DateTime? _selectedDate;

  String? _selectedGender;
  String? _selectedCategory; //Default form selection

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _dob.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedGender == null || _selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select gender and category.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      try {
        final userCred = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: _email.text.trim(),
              password: _password.text.trim(),
            );

        // Send verification email
        await userCred.user!.sendEmailVerification();
        await FirebaseFirestore.instance
            .collection("userinfo")
            .doc(userCred.user!.uid)
            .set({
              "name": _fullName.text.trim(),
              "email": _email.text.trim(),
              "date of birth": _dob.text.trim(),
              "owner": userCred.user!.uid.trim(),
              "category": _selectedCategory,
              "gender": _selectedGender,
            });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Account created!"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => PreferencesPage(userCategory: _selectedCategory!),
          ),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? "An error occurred"),
            backgroundColor: Colors.red,
          ),
        );
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
              SizedBox(height: 70),

              Text(
                "Create An Account",
                textAlign: TextAlign.center,
                style: GoogleFonts.tiroTamil(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 50),

              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Full Name
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      controller: _fullName,
                      decoration: InputDecoration(
                        labelText: "Full Name",
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.circular(10),
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your full name";
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 30),

                    //Email
                    TextFormField(
                      style: TextStyle(color: Colors.white),
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
                    ),

                    SizedBox(height: 30),

                    //password
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      controller: _password,
                      obscureText: _isObscured,
                      decoration: InputDecoration(
                        hintText: "Enter Password",
                        hintStyle: TextStyle(color: Colors.white),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isObscured = !_isObscured;
                            });
                          },
                          icon: Icon(
                            _isObscured
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
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
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 30),

                    //confirm password
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      obscureText: true,
                      controller: _confirmPassword,
                      decoration: InputDecoration(
                        hintText: "Confirm Password",
                        hintStyle: TextStyle(color: Colors.white),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isObscured = !_isObscured;
                            });
                          },
                          icon: Icon(
                            _isObscured
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
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
                      validator: (value) {
                        if (value == null ||
                            _password.text != _confirmPassword.text) {
                          return "Password does not match";
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 30),

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
                      items:
                          ["Male", "Female"].map((category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value!;
                        });
                      },
                    ),

                    SizedBox(height: 30),

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
                      items:
                          ["Mentor", "Mentee"].map((category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),

                    SizedBox(height: 30),

                    //Date of Birth
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1960),
                          lastDate: DateTime.now(),
                        );

                        if (pickedDate != null) {
                          setState(() {
                            _selectedDate = pickedDate;
                            _dob.text =
                                "${pickedDate.year}/${pickedDate.month}/${pickedDate.day}";
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
                        suffixIcon: Icon(Icons.calendar_month_outlined),
                      ),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Select Date of Birth";
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 40),

                    Buttons(
                      text: "Next",
                      onTap: () async {
                        _submitForm();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

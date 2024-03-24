// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shuttlr/services/auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


//this is the sign in page for drivers
//they enter credentials and are redirected to the driver page

class Register extends StatefulWidget {
  final Function toggleView;
  const Register({super.key, required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String email = '';
  String password = '';
  String errorMsg = '';
  bool signingIn = false;

  final _driverFormkey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        //We used singleScrollChild View to allow scrolling of the page when the keyboard pops up for data entry
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 100),
              child: Hero(
                tag: 'logo',
                child: Image.asset(
                  'assets/taxi-driver (1).png',
                  width: 200,
                  height: 200,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 5),
              child: Text(
                "Enter your Driver Credentials",
                style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Text(
                "Please use valid credentials",
                style: GoogleFonts.poppins(color: Colors.grey),
              ),
            ),
            Form(
                key: _driverFormkey,
                child: Column(children: [
                  SizedBox(
                    width: 320,
                    height: 50,
                    child: TextFormField(
                      onChanged: (value) => email = value,
                      validator: (value) {
                        return value!.isEmpty ? 'Please enter an email' : null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: "Email"),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 320,
                    height: 50,
                    child: TextFormField(
                      obscureText: true,
                      onChanged: (value) => password = value,
                      validator: (value) {
                        return value!.isEmpty
                            ? 'Please enter a password'
                            : null;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: "Password"),
                    ),
                  ),
                  Text(
                    errorMsg,
                    style: TextStyle(color: Colors.red),
                  ),
                  GestureDetector(
                    //we use the signingIn bool to check whether the sign in process has begun 
                    //this also allows us to change the button text to a loading widget
                    onTap: () async {
                      if (_driverFormkey.currentState!.validate()) {
                        setState(() {
                          signingIn = true;
                        });
                        try {
                          dynamic result =
                              await _auth.signInWithEmail(email, password);

                          if (result == null) {
                            setState(() {
                              errorMsg = 'Invalid Credentials!';
                              signingIn = false;
                            });
                          }
                        } catch (e) {
                          setState(() {
                            errorMsg = e.toString();
                            signingIn = false;
                          });
                        }
                      }
                    },
                    child: Container(
                        margin: EdgeInsets.only(top: 40, bottom: 10),
                        width: 300,
                        height: 50,
                        decoration: signingIn
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey)
                            : BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromARGB(255, 4, 184, 97)),
                        child: Center(
                            child: signingIn
                                ? SpinKitRing(
                                    color: Colors.white,
                                    lineWidth: 4,
                                    size: 30,
                                  )
                                : Text("Sign In",
                                    style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500)))),
                  ),
                ])),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Looking to catch a bus? ",
                  style: TextStyle(color: Colors.grey),
                ),
                GestureDetector(
                  onTap: () {
                    widget.toggleView();
                  },
                  child: Text(
                    "Sign in as a User",
                    style: TextStyle(color: Color.fromARGB(255, 167, 9, 9)),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                "Shuttlr",
                style: GoogleFonts.fasterOne(
                    fontSize: 60, color: Color.fromARGB(255, 4, 184, 97)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

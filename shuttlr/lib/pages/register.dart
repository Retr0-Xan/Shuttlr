// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shuttlr/services/auth.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  const Register({super.key, required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String email = '';
  String password = '';
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 100),
              child: Hero(
                tag: 'logo',
                child: Image.asset(
                  'assets/bus.png',
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
            SizedBox(
              width: 320,
              height: 50,
              child: TextFormField(
                onChanged: (value) => email = value,
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
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "Password"),
              ),
            ),
            GestureDetector(
              onTap: () async {
                print(email);
                print(password);
                try {
                  await _auth.signInWithEmail(email, password);
                } catch (e) {
                  print(e);
                }
              },
              child: Container(
                  margin: EdgeInsets.only(top: 60, bottom: 10),
                  width: 300,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 4, 184, 97)),
                  child: Center(
                      child: Text("Sign In",
                          style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w500)))),
            ),
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
                    "Login as a User",
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

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shuttlr/services/auth.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  const SignIn({super.key, required this.toggleView});
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String username = '';
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
                "Get started with Shuttlr",
                style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Text(
                "Please provide a username",
                style: GoogleFonts.poppins(color: Colors.grey),
              ),
            ),
            SizedBox(
              width: 320,
              height: 90,
              child: TextFormField(
                onChanged: (value) => username = value,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "Username"),
              ),
            ),
            GestureDetector(
              onTap: () async {
                print(username);
                await _auth.signInAnon();
              },
              child: Container(
                  margin: EdgeInsets.only(top: 70, bottom: 10),
                  width: 300,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 4, 184, 97)),
                  child: Center(
                      child: Text("Sign in",
                          style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w500)))),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "New to Shuttlr? ",
                  style: TextStyle(color: Colors.grey),
                ),
                GestureDetector(
                  onTap: () {
                    widget.toggleView();
                  },
                  child: Text(
                    "Register Now",
                    style: TextStyle(color: Color.fromARGB(255, 167, 9, 9)),
                  ),
                )
              ],
            ),
            Hero(
              tag: 'text',
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Text(
                    "Shuttlr",
                    style: GoogleFonts.fasterOne(
                        fontSize: 60, color: Color.fromARGB(255, 4, 184, 97)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

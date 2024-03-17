// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shuttlr/pages/sign_in.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
                tag: 'logo',
                child: Image.asset("assets/bus.png", width: 200, height: 200)),
            Hero(
              tag: 'text',
              child: Material(
                color: Colors.transparent,
                child: Text(
                  "Shuttlr",
                  style: GoogleFonts.fasterOne(
                      fontSize: 60, color: Color.fromARGB(255, 4, 184, 97)),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Welcome to Shuttlr - Your Ultimate Shuttle Tracking Solution!\nStay informed, stay connected, and enjoy a smoother journey with Shuttlr.",
                style:
                    GoogleFonts.poppins(fontSize: 17, color: Colors.grey[500]),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            SignIn(
                              toggleView: () {
                                Navigator.pushNamed(context, "/register");
                              },
                            ),
                        transitionDuration: Duration(seconds: 1)));
              },
              child: Container(
                  margin: EdgeInsets.only(top: 100, bottom: 10),
                  width: 300,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 4, 184, 97)),
                  child: Center(
                      child: Text("Get Started",
                          style: GoogleFonts.poppins(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.w500)))),
            ),
          ],
        ),
      ),
    );
  }
}

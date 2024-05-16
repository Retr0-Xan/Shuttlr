// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shuttlr/wrapper.dart';

//this is the initial page of the application
//from here we can go to the login screen if the user is not logged in
//or the home screen if he is already logged in
//the widget in charg of the redirection is the wrapper widget
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          Container(
            // Use BoxDecoration to add decoration such as image background
            decoration: BoxDecoration(
              image: DecorationImage(
                // Use AssetImage to load the image from your assets
                image: AssetImage('assets/inside-bus.jpg'),
                // Use BoxFit.fill to stretch the image to fill the entire container
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Container(
            color: Colors.green.withOpacity(0.5),
          ),
          Positioned(
            top: 500,
            left: 20,
            child: Container(
              width: 300,
              child: Text(
                "Welcome to Shuttlr - Your Ultimate Shuttle Tracking Solution!\nStay informed, stay connected, and enjoy a smoother journey with Shuttlr.",
                style: GoogleFonts.righteous(fontSize: 20, color: Colors.white),
              ),
              // merriweather
              //righteous
              // akayakandaka
            ),
          ),
          Positioned(
            top: 600,
            left: 45,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            Wrapper(),
                        transitionDuration: Duration(seconds: 1)));
              },
              child: Container(
                  margin: EdgeInsets.only(top: 100, bottom: 10),
                  width: 300,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: Center(
                      child: Text("> Get Started  ",
                          style: GoogleFonts.poppins(
                              fontSize: 25,
                              color: Colors.blueGrey[500],
                              // blueGrey
                              fontWeight: FontWeight.w500)))),
            ),
          ),
        ],
      ),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: [
      //       Image.asset("assets/shuttlr-logo.png", width: 200, height: 200),
      //       Container(
      //         padding: EdgeInsets.symmetric(horizontal: 20),
      //         child: Text(
      //           "Welcome to Shuttlr - Your Ultimate Shuttle Tracking Solution!\nStay informed, stay connected, and enjoy a smoother journey with Shuttlr.",
      //           style:
      //               GoogleFonts.poppins(fontSize: 17, color: Colors.grey[500]),
      //         ),
      //       ),
      //       GestureDetector(
      //         onTap: () {
      //           Navigator.push(
      //               context,
      //               PageRouteBuilder(
      //                   pageBuilder: (context, animation, secondaryAnimation) =>
      //                       Wrapper(),
      //                   transitionDuration: Duration(seconds: 1)));
      //         },
      //         child: Container(
      //             margin: EdgeInsets.only(top: 100, bottom: 10),
      //             width: 300,
      //             height: 60,
      //             decoration: BoxDecoration(
      //                 borderRadius: BorderRadius.circular(10),
      //                 color: Color.fromARGB(255, 11, 116, 43)),
      //             child: Center(
      //                 child: Text("Get Started",
      //                     style: GoogleFonts.poppins(
      //                         fontSize: 25,
      //                         color: Colors.white,
      //                         fontWeight: FontWeight.w500)))),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}

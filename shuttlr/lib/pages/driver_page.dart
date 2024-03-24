// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shuttlr/services/auth.dart';
import 'package:shuttlr/services/database.dart';


//this is where the drivers will land after signing in with their credentials
//they can start/end sessions here which will update the realtime database

class DriverPage extends StatefulWidget {
  String? uid;

  DriverPage({super.key, this.uid});

  @override
  State<DriverPage> createState() => _DriverPageState();
}

class _DriverPageState extends State<DriverPage> {
  final AuthService _auth = AuthService();

  bool sessionStarted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver page'),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await _auth.signOut();
              })
        ],
      ),
      body: Center(
        child: GestureDetector(
          onTap: () async {
            setState(() {
              //this bool will help us change the state of the button and perform other functions
              sessionStarted = !sessionStarted;
            });
            //start tracking and be updating updateLocation method with new data
            await DatabaseService(uid: widget.uid).updateLocation("123", "122");
          },
          child: Container(
            margin: EdgeInsets.only(top: 40, bottom: 10),
            width: 300,
            height: 50,
            decoration: sessionStarted
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: Colors.red)
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 4, 184, 97)),
            child: Center(
                child: sessionStarted
                    ? Text("Stop Session",
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w500))
                    : Text("Start Session",
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w500))),
          ),
        ),
      ),
    );
  }
}

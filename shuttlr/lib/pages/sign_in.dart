// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shuttlr/components/regin_buttons.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  const SignIn({super.key, required this.toggleView});
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> with WidgetsBindingObserver {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void didChangeMetrics() {
    if (MediaQuery.of(context).viewInsets.bottom == 0.0) {
      // Keyboard dismissed
      _scrollController.jumpTo(0.0); // Scroll back to top
    } else {
      // Keyboard shown
      final offset = _scrollController.offset;
      if (offset > MediaQuery.of(context).viewInsets.bottom) {
        // Adjust scrolling when keyboard appears
        _scrollController.jumpTo(MediaQuery.of(context).viewInsets.bottom);
      }
    }
  }

  void _scrollListener() {
    // Lock scrolling beyond a certain point
    if (_scrollController.offset > 1.0) {
      _scrollController.jumpTo(1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Color.fromARGB(255, 33, 219, 173),
          Color.fromARGB(193, 64, 228, 228),
        ],
        stops: [0.3, 0.9],
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(top: 40),
                width: 350,
                height: 190,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.all(Radius.circular(40))),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Welcome Back",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                      ),
                      Container(
                        height: 60,
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RegInButton(
                                text: "Login",
                                isSelected: true,
                                buttonColor:
                                    MaterialStateProperty.all(Colors.white),
                                toggleView: widget.toggleView),
                            RegInButton(
                                text: "Register",
                                isSelected: false,
                                buttonColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                toggleView: widget.toggleView)
                          ],
                        ),
                      )
                    ]),
              ),
              Text(
                "Shuttlr",
                style: GoogleFonts.fasterOne(fontSize: 60, color: Colors.white),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                        child: Text(
                          "Log In to Shuttlr",
                          style: GoogleFonts.poppins(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          "Make sure that you already have a Shuttlr account.",
                          style:
                              TextStyle(color: Colors.grey[400], fontSize: 12),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              labelText: "Email",
                              labelStyle: GoogleFonts.poppins(
                                  fontSize: 15, color: Colors.grey)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              labelText: "Password",
                              labelStyle: GoogleFonts.poppins(
                                  fontSize: 15, color: Colors.grey)),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ElevatedButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white)),
                              child: Text("Sign in"))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:shuttlr/pages/sign_in.dart';
import 'package:shuttlr/pages/register.dart';
import 'package:flutter/material.dart';


//this widget returns either the sign in page or register page
//(these should change into user sign in or driver sign in. since there is no regisgteration)
class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}


class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showSignIn
        ? SignIn(toggleView: toggleView)
        : Register(toggleView: toggleView);
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shuttlr/pages/sign_in.dart';
import 'package:shuttlr/pages/register.dart';
import 'package:shuttlr/wrapper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => Wrapper(),
        '/signin': (context) => SignIn(
              toggleView: () {
                Navigator.popAndPushNamed(context, "/register");
              },
            ),
        '/register': (context) => Register(toggleView: () {
              Navigator.popAndPushNamed(context, "/signin");
            }),
      },
    );
  }
}

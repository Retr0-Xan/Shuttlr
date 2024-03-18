// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shuttlr/pages/landing_page.dart';
import 'package:shuttlr/pages/sign_in.dart';
import 'package:shuttlr/pages/register.dart';
import 'package:shuttlr/services/auth.dart';
import 'package:shuttlr/wrapper.dart';
import 'package:shuttlr/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => LandingPage(),
          '/signin': (context) => SignIn(
                toggleView: () {
                  Navigator.popAndPushNamed(context, "/register");
                },
              ),
          '/register': (context) => Register(toggleView: () {
                Navigator.popAndPushNamed(context, "/signin");
              }),
        },
      ),
    );
  }
}

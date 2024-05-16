// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shuttlr/pages/authenticate.dart';
import 'package:shuttlr/pages/driver_page.dart';
import 'package:shuttlr/pages/home.dart';
import 'package:provider/provider.dart';
import 'package:shuttlr/pages/sign_in.dart';

//this widget is the determiner of which screen/page to show after the landing page
//it checks if there is a user signed in via the provider
//since the StreamProvider from main.dart allows descendant widgets to access data from the stream
//we access the user data from here and check if there is a user signed in or not
//if no user, it shows the authenticate page for signing in or else it shows either one of the homoe pages

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final username = user?.displayName;
    print(username);
    print(user);
    return user == null
        ? Authenticate()
        : (user.isAnonymous
            ? HomePage(username: username)
            : DriverPage(
                uid: user.uid,
              ));
  }
}

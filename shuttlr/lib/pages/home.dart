// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shuttlr/services/auth.dart';

class HomePage extends StatelessWidget {
  final AuthService _auth = AuthService();

  HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
              // Navigator.pop(context);
            },
          )
        ],
      ),
      body: Center(
        child: Text('Home'),
      ),
    );
  }
}

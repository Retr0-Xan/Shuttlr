// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shuttlr/services/auth.dart';

class DriverPage extends StatelessWidget {
  final AuthService _auth = AuthService();

  DriverPage({super.key});
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
            },
          )
        ],
      ),
      body: Center(
        child: Text('Driver Page'),
      ),
    );
  }
}

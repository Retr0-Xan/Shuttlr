// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shuttlr/services/auth.dart';
import 'package:shuttlr/services/database.dart';
import 'package:provider/provider.dart';

class DriverPage extends StatelessWidget {
  final AuthService _auth = AuthService();
  String? uid;

  DriverPage({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      initialData: null,
      value: AuthService().user,
      child: Scaffold(
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
          child: ElevatedButton(
            child: Text("Start Session"),
            onPressed: () async {
              User? user = Provider.of<User?>(context, listen: false);
              uid = user?.uid;
              await DatabaseService(uid: uid).updateLocation("246", "359");
            },
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shuttlr/services/auth.dart';
import 'package:shuttlr/services/database.dart';

class HomePage extends StatelessWidget {
  final AuthService _auth = AuthService();

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot?>.value(
      initialData: null,
      value: DatabaseService().locations,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
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
          child: Consumer<QuerySnapshot?>(
            builder: (context, locationsSnapshot, _) {
              if (locationsSnapshot == null) {
                // Data is still loading
                return CircularProgressIndicator();
              }

              // Handle errors
              if (locationsSnapshot.docs.isEmpty) {
                return Text('No data available');
              }

              // Data has been successfully fetched
              final locations = locationsSnapshot.docs;

              return ListView.builder(
                itemCount: locations.length,
                itemBuilder: (context, index) {
                  final locationData = locations[index].data() as Map<String,
                      dynamic>; // Explicit cast to Map<String, dynamic>
                  final longitude = locationData['longitude'];
                  final latitude = locationData['latitude'];
                  return ListTile(
                    title: Text('Longitude: $longitude, Latitude: $latitude'),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

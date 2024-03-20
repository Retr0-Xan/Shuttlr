// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shuttlr/services/auth.dart';
import 'package:shuttlr/services/database.dart';

class HomePage extends StatelessWidget {
  final AuthService _auth = AuthService();
  static const LatLng _sourceLoc = LatLng(6.661088, -1.621181);
  static const LatLng _destLoc = LatLng(6.668746, -1.574481);

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot?>.value(
      initialData: null,
      value: DatabaseService().locations,
      child: Scaffold(
        drawer: Drawer(
          backgroundColor: Colors.grey[200],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  DrawerHeader(child: Image.asset('assets/bus.png')),
                  SizedBox(
                    height: 30,
                  ),
                  ListTile(
                      iconColor: Colors.black,
                      textColor: Colors.black,
                      contentPadding: EdgeInsets.only(left: 30),
                      title: const Text("Home"),
                      leading: const Icon(Icons.home),
                      onTap: () {
                        Navigator.pushNamed(context, '/home');
                      }),
                  ListTile(
                      iconColor: Colors.black,
                      textColor: Colors.black,
                      contentPadding: EdgeInsets.only(left: 30),
                      title: const Text("About"),
                      leading: const Icon(Icons.info),
                      onTap: () {
                        Navigator.pushNamed(context, '/home');
                      }),
                ],
              ),
              Column(
                children: [
                  ListTile(
                      iconColor: Colors.black,
                      textColor: Colors.black,
                      contentPadding: EdgeInsets.only(left: 30),
                      title: const Text("Logout"),
                      leading: const Icon(Icons.logout),
                      onTap: () {
                        _auth.signOut();
                      }),
                ],
              )
            ],
          ),
        ),
        body: Consumer<QuerySnapshot?>(
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

            return Stack(
              children: [
                GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: _sourceLoc, zoom: 13.5),
                  markers: {     
                    Marker(
                        markerId: MarkerId("sourceLoc"),
                        icon: BitmapDescriptor.defaultMarker,
                        position: _sourceLoc),
                    Marker(
                        markerId: MarkerId("destLoc"),
                        icon: BitmapDescriptor.defaultMarker,
                        position: _destLoc),
                  },
                ),
                Positioned(
                  left: 20,
                  top: 30,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.transparent, width: 0),
                        borderRadius: BorderRadius.circular(60)),
                    child: IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: Icon(Icons.menu),
                      iconSize: 30,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

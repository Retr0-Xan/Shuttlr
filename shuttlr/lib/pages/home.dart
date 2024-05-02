// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shuttlr/services/auth.dart';
import 'package:shuttlr/services/database.dart';

//This is the home page for users(riders)
//it displays a map view with markers showing the current active tracking sessions

class HomePage extends StatelessWidget {
  final AuthService _auth = AuthService();
  static const LatLng _initialLoc =
      LatLng(6.6732588425127135, -1.5674974485816102);
  // static const LatLng _destLoc = LatLng(6.668746, -1.574481);
  Map<String, Map<String, String>> myCoordinatesMap = {};

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //we are making the location data stream available to the home widget
    //because we need that data to be able to track the buses on the map
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
        //we are using the consumer with the data from the provider to be able to access and use that data
        //with the consumer we return the actual map widget which will now have access to the data from the provider
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
            //putting all my coordinates from database into a my own map
            //my own map because the firebase querysnapshot was not really allowing me to access the data the way i wanted
            for (var doc in locationsSnapshot.docs) {
              // Extract the data map from the document
              Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

              // Check if the data is not null and contains the keys 'latitude' and 'longitude'
              if (data != null &&
                  data.containsKey('latitude') &&
                  data.containsKey('longitude')) {
                // Create a new map for the coordinates
                Map<String, String> coordinates = {
                  'latitude': data['latitude'].toString(),
                  'longitude': data['longitude'].toString()
                };
                // Add the coordinates to your own map using the document ID as the key
                myCoordinatesMap[doc.id] = coordinates;
              }
            }
            // Data has been successfully fetched
            return Stack(children: [
              GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: _initialLoc, zoom: 13.5),
                markers:
                    //we look at the length of myCoordinates map which holds all the current logged in drivers coordinates
                    // we bulid the markers based on that data
                    //markers are updated accordingly
                    Set<Marker>.of(
                  myCoordinatesMap.keys.map((documentId) {
                    Map<String, String> coordinates =
                        myCoordinatesMap[documentId]!;

                    if (coordinates['latitude']!.isNotEmpty &&
                        coordinates['longitude']!.isNotEmpty) {
                      double latitude = double.parse(coordinates['latitude']!);
                      double longitude =
                          double.parse(coordinates['longitude']!);

                      return Marker(
                          markerId: MarkerId(documentId),
                          icon: BitmapDescriptor.defaultMarker,
                          position: LatLng(latitude, longitude));
                    } else {
                      return null;
                    }
                  }).whereType<Marker>(),
                ),
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
            ]);
          },
        ),
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shuttlr/services/auth.dart';
import 'package:shuttlr/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

//This is the home page for users(riders)
//it displays a map view with markers showing the current active tracking sessions

class HomePage extends StatefulWidget {
  static const LatLng _initialLoc =
      LatLng(6.6732588425127135, -1.5674974485816102);

  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LatLng UniCampusNE = LatLng(6.688318, -1.564417);
  final LatLng UniCampusSW = LatLng(6.666382, -1.587739);
  final AuthService _auth = AuthService();
  User? current_user = FirebaseAuth.instance.currentUser;

  Map<String, Map<String, String>> myCoordinatesMap = {};

  BitmapDescriptor busIcon = BitmapDescriptor.defaultMarker;

  void setCustomMarker() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/bus-marker-green.png")
        .then((icon) {
      busIcon = icon;
    });
  }

  @override
  Widget build(BuildContext context) {
    setCustomMarker();
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        width: 60,
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.fromLTRB(20, 50, 0, 0),
                        child: Icon(
                          Icons.person,
                          size: 40.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50, left: 10),
                        child: Text(
                          //over here we are getting the data from the current user signed in
                          //if for som reason, the display name did not update, we display a generic name
                          current_user?.displayName == null
                              ? "Anonymous"
                              : current_user!.displayName!,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      )
                    ],
                  ),
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
                myLocationEnabled: true,
                trafficEnabled: false,
                cameraTargetBounds: CameraTargetBounds(
                  LatLngBounds(
                    northeast: UniCampusNE,
                    southwest: UniCampusSW,
                  ),
                ),
                mapType: MapType.normal,
                initialCameraPosition:
                    CameraPosition(target: HomePage._initialLoc, zoom: 14),
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
                          icon: busIcon,
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

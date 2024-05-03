// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shuttlr/services/auth.dart';
import 'package:shuttlr/services/database.dart';

//this is where the drivers will land after signing in with their credentials
//they can start/end sessions here which will update the realtime database

class DriverPage extends StatefulWidget {
  String? uid;

  DriverPage({super.key, this.uid});

  @override
  State<DriverPage> createState() => _DriverPageState();
}

class _DriverPageState extends State<DriverPage> {
  void getPermissions() async {
    var status = await Permission.locationWhenInUse.status;
    if (!status.isGranted) {
      status = await Permission.locationWhenInUse.request();
    }
    if (status.isGranted) {
      status = await Permission.locationAlways.request();
    }
  }

  @override
  void initState() {
    super.initState();
    getPermissions();
  }

  final AuthService _auth = AuthService();

  bool sessionStarted = false;
  LocationData? currentLocation;
  StreamSubscription<LocationData>? locationSubscription;

  void getCurrentLocation(bool sessionStatus) async {
  Location location = Location();
  location.enableBackgroundMode();
    if (sessionStatus == true) {
      location.getLocation().then(
        (location) async {
          currentLocation = location;
          await DatabaseService(uid: widget.uid).updateLocation(
              (currentLocation!.latitude).toString(),
              (currentLocation!.longitude).toString());
        },
      );
      // ignore: prefer_conditional_assignment
      if (locationSubscription == null) {
        locationSubscription = location.onLocationChanged.listen((newLocation) {
          currentLocation = newLocation;
          setState(() async {
            await DatabaseService(uid: widget.uid).updateLocation(
                (currentLocation!.latitude).toString(),
                (currentLocation!.longitude).toString());
          });
        });
      }
    } else if (sessionStatus == false) {
      locationSubscription?.cancel();
      locationSubscription = null;

      await DatabaseService(uid: widget.uid).updateLocation("", "");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver page'),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                DatabaseService(uid: widget.uid).updateLocation("", "");
                await _auth.signOut();
              })
        ],
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              //this bool will help us change the state of the button and perform other functions
              sessionStarted = !sessionStarted;
            });
            //start tracking and be updating updateLocation method with new data if session has been started
            if (sessionStarted == true) {
              getCurrentLocation(sessionStarted);
            } else if (sessionStarted == false) {
              //if session has ended remove coordinates to remove marker from map
              getCurrentLocation(sessionStarted);
            }
          },
          child: Container(
            margin: EdgeInsets.only(top: 40, bottom: 10),
            width: 300,
            height: 50,
            decoration: sessionStarted
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: Colors.red)
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 4, 184, 97)),
            child: Center(
                child: sessionStarted
                    ? Text("Stop Session",
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w500))
                    : Text("Start Session",
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w500))),
          ),
        ),
      ),
    );
  }
}

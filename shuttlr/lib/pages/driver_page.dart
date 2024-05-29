// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_const_literals_to_create_immutables

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

  Future<dynamic> updateLocation(String latitude, String longitude) async {
    await DatabaseService(uid: widget.uid).updateLocation(latitude, longitude);
  }

  @override
  void initState() {
    super.initState();
    getPermissions();
  }

  final AuthService _auth = AuthService();
  int _selectedNavBarIndex = 1;
  bool sessionStarted = false;
  LocationData? currentLocation;
  StreamSubscription<LocationData>? locationSubscription;

  // void stopTracking(bool sessionStatus) async {
  //   Location location = Location();

  //   location.enableBackgroundMode(enable: false);
  //   location.
  // }

  void getCurrentLocation(bool sessionStatus) async {
    Location location = Location();
    location.enableBackgroundMode(enable: true);
    location.changeSettings(accuracy: LocationAccuracy.high);
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
          updateLocation((currentLocation!.latitude).toString(),
              (currentLocation!.longitude).toString());
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
        onTap: (value) {
          if (value == 0) {
            // Navigator.pushNamed(context, '/home');
            print(value);
            setState(() {
              _selectedNavBarIndex = value;
            });
          } else if (value == 1) {
            // Navigator.pushNamed(context, '/create');
            print(value);
            setState(() {
              _selectedNavBarIndex = value;
            });
          } else {
            // Navigator.pushNamed(context, '/history');
            print(value);
            setState(() {
              _selectedNavBarIndex = value;
            });
          }
        },
        currentIndex: _selectedNavBarIndex,
        selectedItemColor: Colors.green,
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Driver page'),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                locationSubscription?.cancel();
                locationSubscription = null;
                updateLocation("", "");
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
              locationSubscription?.cancel();
              locationSubscription = null;

              updateLocation("", "");
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

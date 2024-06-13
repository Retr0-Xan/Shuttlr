// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shuttlr/pages/create_session.dart';
import 'package:shuttlr/pages/driver_history.dart';
import 'package:shuttlr/pages/driver_home.dart';
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
  Future<dynamic> updateLocation(
      String latitude, String longitude, String route) async {
    await DatabaseService(uid: widget.uid)
        .updateLocation(latitude, longitude, route, "");
  }

  final AuthService _auth = AuthService();
  int _selectedNavBarIndex = 0;
  bool sessionStarted = false;
  LocationData? currentLocation;
  StreamSubscription<LocationData>? locationSubscription;

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
              (currentLocation!.longitude).toString(),
              "",
              "");
        },
      );
      // ignore: prefer_conditional_assignment
      if (locationSubscription == null) {
        locationSubscription = location.onLocationChanged.listen((newLocation) {
          currentLocation = newLocation;
          updateLocation((currentLocation!.latitude).toString(),
              (currentLocation!.longitude).toString(), "");
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      DriverHome(),
      CreateSession(
        uid: widget.uid,
      ),
      DriverHistory(),
    ];
    //Using a stream provider to make the locations stream from DatabaseService available to all widgets under this
    return StreamProvider<QuerySnapshot?>.value(
      initialData: null,
      value: DatabaseService().locations,
      child: Scaffold(
          bottomNavigationBar: NavigationBar(
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.add),
                label: 'Create',
              ),
              NavigationDestination(
                icon: Icon(Icons.history),
                label: 'History',
              ),
            ],
            onDestinationSelected: (value) {
              if (value == 0) {
                setState(() {
                  _selectedNavBarIndex = value;
                });
              } else if (value == 1) {
                setState(() {
                  _selectedNavBarIndex = value;
                });
              } else {
                setState(() {
                  _selectedNavBarIndex = value;
                });
              }
            },
            selectedIndex: _selectedNavBarIndex,
            height: 70,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          ),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text('Shuttlr Driver'),
            actions: [
              IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () async {
                    locationSubscription?.cancel();
                    locationSubscription = null;
                    updateLocation("", "", "");
                    await _auth.signOut();
                  })
            ],
          ),
          body: IndexedStack(
            index: _selectedNavBarIndex,
            children: _pages,
          )),
    );
  }
}

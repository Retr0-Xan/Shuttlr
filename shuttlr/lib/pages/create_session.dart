// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shuttlr/services/database.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class CreateSession extends StatefulWidget {
  final String? uid;
  String route = "";
  String dropdownValue = "Brunei";

  CreateSession({super.key, this.uid});

  @override
  State<CreateSession> createState() => _CreateSessionState();
}

class _CreateSessionState extends State<CreateSession> {
  void getPermissions() async {
    var status = await Permission.locationWhenInUse.status;
    if (!status.isGranted) {
      status = await Permission.locationWhenInUse.request();
    }
    if (status.isGranted) {
      status = await Permission.locationAlways.request();
    }
  }

  Future<dynamic> updateLocation(
      String latitude, String longitude, String route) async {
    await DatabaseService(uid: widget.uid)
        .updateLocation(latitude, longitude, route);
  }

  Future<dynamic> updateHistory(String route, String timeElapsed) async {
    await DatabaseService(uid: widget.uid).updateHistory(route, timeElapsed);
  }

  @override
  void initState() {
    super.initState();
    getPermissions();
  }

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  final _isHours = true;
  String displayTime =
      StopWatchTimer.getDisplayTime(0, hours: true, milliSecond: false);

  bool sessionStarted = false;
  LocationData? currentLocation;
  StreamSubscription<LocationData>? locationSubscription;

  // void stopTracking(bool sessionStatus) async {
  //   Location location = Location();

  //   location.enableBackgroundMode(enable: false);
  //   location.
  // }

  void getCurrentLocation(bool sessionStatus, String route) async {
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
              route);
        },
      );
      // ignore: prefer_conditional_assignment
      if (locationSubscription == null) {
        locationSubscription = location.onLocationChanged.listen((newLocation) {
          currentLocation = newLocation;
          updateLocation((currentLocation!.latitude).toString(),
              (currentLocation!.longitude).toString(), route);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(
            "Select Route",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          DropdownButton(
              items: const [
                DropdownMenuItem(
                  value: "Brunei",
                  child: Text("Brunei - KSB"),
                ),
                DropdownMenuItem(
                  value: "Commercial Area",
                  child: Text("Commercial Area - KSB"),
                ),
                DropdownMenuItem(
                  value: "Mombasa",
                  child: Text("Mombasa"),
                ),
              ],
              value: widget.dropdownValue,
              onChanged: (String? newValue) {
                setState(() {
                  widget.dropdownValue = newValue!;
                });
              }),
          GestureDetector(
            onTap: () {
              setState(() {
                //this bool will help us change the state of the button and perform other functions
                sessionStarted = !sessionStarted;
                widget.route = widget.dropdownValue;
              });
              //start tracking and be updating updateLocation method with new data if session has been started
              if (sessionStarted == true) {
                getCurrentLocation(sessionStarted, widget.route);
                _stopWatchTimer.onExecute.add(StopWatchExecute.start);
              } else if (sessionStarted == false) {
                _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                updateHistory(widget.route, displayTime);
                _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                //if session has ended remove coordinates to remove marker from map
                locationSubscription?.cancel();
                locationSubscription = null;

                updateLocation("", "", "");
              }
            },
            child: Container(
              margin: EdgeInsets.only(top: 40, bottom: 10),
              width: 300,
              height: 50,
              decoration: sessionStarted
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.red)
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
          StreamBuilder<int>(
              stream: _stopWatchTimer.rawTime,
              initialData: _stopWatchTimer.rawTime.value,
              builder: ((context, snapshot) {
                final value = snapshot.data!;
                displayTime = StopWatchTimer.getDisplayTime(value,
                    hours: _isHours, milliSecond: false);
                return Text(displayTime,
                    style: GoogleFonts.poppins(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.w500));
              }))
        ],
      ),
    );
  }
}

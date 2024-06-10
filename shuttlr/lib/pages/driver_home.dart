// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shuttlr/services/database.dart';

class DriverHome extends StatefulWidget {
  const DriverHome({super.key});

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  int itemCount = 0;
  String dataText = "";
  @override
  Widget build(BuildContext context) {
    //using the stream provided in the parent widget(driver page) we can now access all that data
    final locations = Provider.of<QuerySnapshot?>(context)!;
    final List<Map<String, dynamic>> validLocationData = locations.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .where((data) =>
            data['longitude'] != "" &&
            data['latitude'] != "" &&
            data['route'] != "")
        .toList();
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "Current Sessions",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          validLocationData.isEmpty
              ? Center(child: Text('No drivers at this time'))
              : Expanded(
                  child: ListView.builder(
                    itemCount: validLocationData.length,
                    itemBuilder: (context, index) {
                      final data = validLocationData[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Container(
                          color: Colors.green,
                          height: 130,
                          width: double.infinity,
                          child:
                              Center(child: Text(data['route'] ?? 'No Data')),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}

        // Padding(
        //   padding: const EdgeInsets.only(left: 17),
        //   child: Container(
        //     color: Colors.green,
        //     height: 130,
        //     width: 320,
        //     child: Center(child: Text(firstLoc['route'])),
        //   ),
        // )
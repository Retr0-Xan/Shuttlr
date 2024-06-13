// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final histories = Provider.of<QuerySnapshot?>(context)!;
    final List<Map<String, dynamic>> validLocationData = locations.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .where((data) =>
            data['longitude'] != "" &&
            data['latitude'] != "" &&
            data['route'] != "" &&
            data['time_elapsed'] != "")
        .toList();
    return Scaffold(
      backgroundColor: Colors.grey[200],
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
                            decoration: BoxDecoration(
                                color: Colors.white54,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 7,
                                    spreadRadius: 5,
                                  ),
                                ]),
                            height: 150,
                            width: double.infinity,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 8, 50, 8),
                                  child: Container(
                                    color: Colors.green,
                                    height: 110,
                                    width: 120,
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      data['route'] ?? 'No Data',
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(data['time_elapsed'] ?? 'No Data'),
                                  ],
                                ),
                              ],
                            )),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}

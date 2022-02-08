import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/service/database.dart';
import 'package:fyp2/service/location.dart';

class ScanCL extends StatefulWidget {
  ScanCL({Key key}) : super(key: key);

  @override
  State<ScanCL> createState() => _ScanCLState();
}

class _ScanCLState extends State<ScanCL> {
  String userID = FirebaseAuth.instance.currentUser.uid;
  List<String> id = [];
  List<double> distance = [];

  Future<List<Map<String, dynamic>>> _computeDistance() async {
    double startLat;
    double startLng;
    List<double> endLat = [];
    List<double> endLng = [];
    List<String> clID = [];
    List<Map<String, dynamic>> distanceData = [];

    await Database().getUserData(userID).then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> userData = snapshot.data();
        startLat = userData['latitude'];
        startLng = userData['longitude'];
      }
    });

    await FirebaseFirestore.instance
        .collection('users')
        .where('userType', isEqualTo: 'Confinement Lady')
        .get()
        .then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        endLat.add(doc['latitude']);
        endLng.add(doc['longitude']);
        clID.add(doc['id']);
      }
    });

    for (var i = 0; i < endLat.length; i++) {
      double distance = double.parse(LocationService()
          .distance(startLat, startLng, endLat[i], endLng[i])
          .toStringAsFixed(2));
      print(distance);

      distanceData.add({
        'id': clID[i],
        'distance': distance,
      });
    }

    print(distanceData);
    return distanceData;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SizedBox(
          height: MediaQuery.of(context).size.height * 0.80,
          child: FutureBuilder(
            future: _computeDistance(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final futureDocs = snapshot.data;
                for (var doc in futureDocs) {
                  id.add(doc['id']);
                  distance.add(doc['distance']);
                }
                return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('userType', isEqualTo: 'Confinement Lady')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          final doc = snapshot.data.docs[index];
                          if (id.contains(doc['id'])) {
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: ExpansionTile(
                                iconColor: Colors.orange,
                                leading: CircleAvatar(
                                  // backgroundColor: Colors.red,
                                  backgroundImage:
                                      NetworkImage(doc['imageUrl']),
                                ),
                                title: Column(
                                  children: [
                                    Text(
                                      doc['name'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Rating :',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        Row(
                                          children: [
                                            for (int i = 1;
                                                i <= doc['rating'].round();
                                                i++)
                                              const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              )
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: distance[index] > 1
                                          ? Text(
                                              'Within ' +
                                                  distance[index].toString() +
                                                  ' km',
                                              style: const TextStyle(
                                                  color: Colors.grey),
                                            )
                                          : Text(
                                              'Within ' +
                                                  (distance[index] * 1000)
                                                      .toString() +
                                                  ' m',
                                              style: const TextStyle(
                                                  color: Colors.grey),
                                            ),
                                    ),
                                  ],
                                ),
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.grey.shade300),
                                    child: doc['description'] ==
                                            'Briefly introduce yourself'
                                        ? const Text(
                                            'The user not yet display any description')
                                        : Text(doc['description']),
                                  ),
                                  ElevatedButton.icon(
                                      onPressed: () {},
                                      icon: const Icon(Icons.favorite),
                                      label: const Text('Pick Me'))
                                ],
                              ),
                            );
                          } else {
                            return const Text('error');
                          }
                        },
                        itemCount: snapshot.data.docs.length,
                      );
                    } else {
                      return const Text('no data');
                    }
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ));
  }
}

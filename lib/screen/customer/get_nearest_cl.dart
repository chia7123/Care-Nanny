import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/screen/customer/service_detail.dart';
import 'package:fyp2/service/database.dart';
import 'package:fyp2/service/location.dart';
import 'package:fyp2/widgets/profile_card.dart';

class GetNearestCL extends StatefulWidget {
  GetNearestCL({Key key}) : super(key: key);

  @override
  State<GetNearestCL> createState() => _GetNearestCLState();
}

class _GetNearestCLState extends State<GetNearestCL> {
  String userID = FirebaseAuth.instance.currentUser.uid;

  Stream stream = FirebaseFirestore.instance
      .collection('users')
      .where('tempDistance', isGreaterThanOrEqualTo: 0)
      .orderBy('tempDistance')
      .snapshots();

  _computeDistance() async {
    double startLat;
    double startLng;

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
        double distance = double.parse(LocationService()
            .distance(startLat, startLng, doc['latitude'], doc['longitude'])
            .toStringAsFixed(2));

        Database().updateUserData(doc['id'], {'tempDistance': distance});
      }
    });
  }

  dynamic showBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.43,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Distance Filter',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          stream = FirebaseFirestore.instance
                              .collection('users')
                              .where('tempDistance', isGreaterThanOrEqualTo: 0)
                              .orderBy('tempDistance')
                              .snapshots();
                        });
                      },
                      icon: const Icon(Icons.restore),
                      label: const Text('Reset'),
                    )
                  ],
                ),
              ),
              const Divider(
                thickness: 0.5,
                color: Colors.black,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.31,
                child: ListView(
                  children: [
                    TextButton(
                      child: const Text('< 10 km'),
                      onPressed: () {
                        setState(() {
                          stream = FirebaseFirestore.instance
                              .collection('users')
                              .where('tempDistance', isLessThanOrEqualTo: 10)
                              .orderBy('tempDistance')
                              .snapshots();
                        });
                      },
                    ),
                    const Divider(),
                    TextButton(
                      child: const Text('< 25 km'),
                      onPressed: () {
                        setState(() {
                          stream = FirebaseFirestore.instance
                              .collection('users')
                              .where('tempDistance', isLessThanOrEqualTo: 25)
                              .orderBy('tempDistance')
                              .snapshots();
                        });
                      },
                    ),
                    const Divider(),
                    TextButton(
                      child: const Text('< 50 km'),
                      onPressed: () {
                        setState(() {
                          stream = FirebaseFirestore.instance
                              .collection('users')
                              .where('tempDistance', isLessThanOrEqualTo: 50)
                              .orderBy('tempDistance')
                              .snapshots();
                        });
                      },
                    ),
                    const Divider(),
                    TextButton(
                      child: const Text('< 100 km'),
                      onPressed: () {
                        setState(() {
                          stream = FirebaseFirestore.instance
                              .collection('users')
                              .where('tempDistance', isLessThanOrEqualTo: 100)
                              .orderBy('tempDistance')
                              .snapshots();
                        });
                      },
                    ),
                    const Divider(),
                    TextButton(
                      child: const Text('100 km and above'),
                      onPressed: () {
                        setState(() {
                          stream = FirebaseFirestore.instance
                              .collection('users')
                              .where('tempDistance',
                                  isGreaterThanOrEqualTo: 100)
                              .orderBy('tempDistance')
                              .snapshots();
                        });
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void hire(String id, String name) {
    Database().addTempData(id, {
      'id': id,
      'name': name,
    });
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ServiceDetailScreen(),
        ));
  }

  @override
  void initState() {
    _computeDistance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton.icon(
            onPressed: () => showBottomSheet(context),
            icon: const Icon(
              Icons.filter_list_outlined,
              color: Colors.white,
            ),
            label: const Text(
              'Filter',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: SizedBox(
          height: MediaQuery.of(context).size.height * 0.80,
          child: StreamBuilder(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final doc = snapshot.data.docs[index];
                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: ExpansionTile(
                        iconColor: Colors.orange,
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(doc['imageUrl']),
                        ),
                        title: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  doc['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                ProfileCard(doc['id']),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Rating :',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    doc['rating'] == 0
                                        ? const Text(
                                            ' No rating yet',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          )
                                        : Row(
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
                                doc['tempDistance'] > 1
                                    ? Text(
                                        'Within ' +
                                            doc['tempDistance'].toString() +
                                            ' km',
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      )
                                    : Text(
                                        'Within ' +
                                            (doc['tempDistance'] * 1000)
                                                .toString() +
                                            ' m',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        ),
                        children: [
                          ElevatedButton.icon(
                              onPressed: () {
                                hire(doc['id'], doc['name']);
                              },
                              icon: const Icon(Icons.favorite),
                              label: const Text('Hire Me'))
                        ],
                      ),
                    );
                  },
                  itemCount: snapshot.data.docs.length,
                );
              } else {
                return const Center(
                  child: Text('No data'),
                );
              }
            },
          )),
    );
  }
}

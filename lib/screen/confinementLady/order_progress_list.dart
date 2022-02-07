import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/widgets/confinementLady/order/order_progress_detail.dart';
import 'package:intl/intl.dart';

class CLProgressOrderList extends StatelessWidget {
  static const routeName = 'clProgressOrder';
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progress Order'),),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('onProgressOrder')
            .where('clID', isEqualTo: user.uid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
             if (snapshot.data.docs.isEmpty) {
              return const Center(child: Text('No Progress Order'),);
            }
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                final doc = snapshot.data.docs[index];
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CLProgressOrderDetail(doc['orderID']),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey[200]),
                              child: Text(
                                '${index + 1}.  ' + doc['typeOfService'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.grey[800],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            color: Colors.grey[200],
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    const Text('Confinement Lady: '),
                                    Text(doc['clName']),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Confinement Date: ' +
                                        DateFormat('dd-MM-yyyy').format(
                                            doc['selectedDate'].toDate())),
                                    Text('Price: RM ' +
                                        doc['price'].toStringAsFixed(2)),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.grey[800],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Ordered by : ' +
                                DateFormat('MMMM dd, yyyy')
                                    .format(doc['creationDate'].toDate())),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Divider(
                            color: Colors.grey[800],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Text('no data');
          }
        },
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/service/database.dart';
import 'package:fyp2/widgets/profile_card.dart';

class ConLadyList extends StatelessWidget {
  CollectionReference orderInfo =
      FirebaseFirestore.instance.collection('orderInfo');
  final user = FirebaseAuth.instance.currentUser;

  final String orderID;

  ConLadyList(this.orderID, {Key key}) : super(key: key);

  Future hire(BuildContext ctx, String id, String name, String phone) {
    return Database().updateOrderData(orderID, {
      'clID': id,
      'clName': name,
      'clContact': phone,
    }).whenComplete(() {
      Navigator.of(ctx).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
                margin: const EdgeInsets.only(left: 20, top: 20),
                width: double.infinity,
                child: const Text(
                  'Please Select your Nanny',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  softWrap: true,
                )),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.76,
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('userType', isEqualTo: 'Confinement Lady')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          final user = snapshot.data.docs[index];
                          if (user['userType'] == 'Confinement Lady') {
                            return Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: ExpansionTile(
                                iconColor: Colors.orange,
                                leading: CircleAvatar(
                                  // backgroundColor: Colors.red,
                                  backgroundImage:
                                      NetworkImage(user['imageUrl']),
                                ),
                                title: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          user['name'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        ProfileCard(user['id']),
                                      ],
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
                                        user['rating'] == 0
                                            ? const Text(
                                                ' No rating yet',
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              )
                                            : Row(
                                                children: [
                                                  for (int i = 1;
                                                      i <=
                                                          user['rating']
                                                              .round();
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
                                    )
                                  ],
                                ),
                                children: [
                                  ElevatedButton.icon(
                                      onPressed: () => hire(
                                            context,
                                            user['id'],
                                            user['name'],
                                            user['phone'],
                                          ),
                                      icon: const Icon(Icons.favorite),
                                      label: const Text('Hire Me'))
                                ],
                              ),
                            );
                          } else {
                            return null;
                          }
                        });
                  } else {
                    return const Text('no data');
                  }
                }),
          ),
        ],
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/widgets/profile_card.dart';

class ConLadyList extends StatelessWidget {
  CollectionReference orderInfo =
      FirebaseFirestore.instance.collection('orderInfo');
  final user = FirebaseAuth.instance.currentUser;
  Function(String id) selectCL;

  ConLadyList({Key key, this.selectCL}) : super(key: key);

  void _selectCL(BuildContext context, String id) {
    selectCL(id);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confinement Lady List'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        height: MediaQuery.of(context).size.height * 0.9,
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
                            leading: CachedNetworkImage(
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              imageUrl: user['imageUrl'],
                              imageBuilder: (context, imageProvider) =>
                                  CircleAvatar(
                                backgroundImage: imageProvider,
                              ),
                            ),
                            title: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                            style:
                                                TextStyle(color: Colors.grey),
                                          )
                                        : Row(
                                            children: [
                                              for (int i = 1;
                                                  i <= user['rating'].round();
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
                                  onPressed: () {
                                    _selectCL(context, user['id']);
                                  },
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
    );
  }
}

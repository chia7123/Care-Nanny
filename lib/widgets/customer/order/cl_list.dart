import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/screen/customer/cl_detail.dart';
import 'package:fyp2/widgets/profile_card.dart';

class ConLadyList extends StatelessWidget {
  CollectionReference orderInfo =
      FirebaseFirestore.instance.collection('orderInfo');
  final user = FirebaseAuth.instance.currentUser;
  ConLadyList({
    Key key,
  }) : super(key: key);

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
                              borderRadius: BorderRadius.circular(15)),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
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
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  user['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                const Text(
                                  ' | ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                Text(
                                  '${user['age']} y/o',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              children: [
                                user['rating'] == 0
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          for (int i = 1; i <= 5; i++)
                                            const Icon(
                                              Icons.star_border,
                                              color: Colors.amber,
                                            )
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          for (int i = 1;
                                              i <= user['rating'].round();
                                              i++)
                                            const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                          for (int i = 1;
                                              i <= 5 - user['rating'].round();
                                              i++)
                                            const Icon(
                                              Icons.star_border,
                                              color: Colors.amber,
                                            )
                                        ],
                                      ),
                                Table(children: [
                                  TableRow(children: [
                                    const Text('Race :'),
                                    Text(user['race']),
                                  ]),
                                  TableRow(children: [
                                    const Text('Religion :'),
                                    Text(user['religion']),
                                  ]),
                                  TableRow(children: [
                                    const Text('Nationality :'),
                                    Text(user['nationality']),
                                  ]),
                                  TableRow(children: [
                                    const Text('Vegetarian :'),
                                    user['vegan']
                                        ? const Text('Yes')
                                        : const Text('No'),
                                  ]),
                                ]),
                              ],
                            ),
                            style: ListTileStyle.list,
                            onTap: () {
                              // _selectCL(context, user['id']);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CLProfileDetail(
                                    id: user['id'],
                                  ),
                                ),
                              );
                            },
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

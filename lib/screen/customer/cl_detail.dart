import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/widgets/full_screen_image.dart';
import 'package:intl/intl.dart';

class CLProfileDetail extends StatelessWidget {
  CLProfileDetail({Key key, this.id}) : super(key: key);
  final String id;

  Stream<QuerySnapshot<Object>> stream(dynamic doc) {
    List<Stream> list = [
      FirebaseFirestore.instance
          .collection('users')
          .where('vegan', isEqualTo: doc['vegan'])
          .snapshots(),
      FirebaseFirestore.instance
          .collection('users')
          .where('race', isEqualTo: doc['race'])
          .snapshots(),
      FirebaseFirestore.instance
          .collection('users')
          .where('religion', isEqualTo: doc['religion'])
          .snapshots(),
    ];

    Stream element = list[Random().nextInt(list.length)];

    return (element);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection('users').doc(id).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Something went wrong"),
          );
        }
        if (snapshot.connectionState == ConnectionState.active) {
          final doc = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Profile Detail'),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.78,
                    child: content(context, doc),
                  ),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text('Hire Me'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      },
    );
  }

  Widget content(BuildContext context, dynamic doc) {
    return SingleChildScrollView(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FullScreenImage(imageUrl: doc['imageUrl']),
                )),
            child: CachedNetworkImage(
              imageUrl: doc['imageUrl'],
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey,
                child: Center(
                  child: Icon(
                    Icons.error,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height * 0.45,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      doc['name'],
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      '${doc['age'].toString()} y/o',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    doc['rating'] == 0
                        ? Row(
                            children: [
                              for (int i = 1; i <= 5; i++)
                                const Icon(
                                  Icons.star_border,
                                  color: Colors.amber,
                                )
                            ],
                          )
                        : Row(
                            children: [
                              for (int i = 1; i <= doc['rating'].round(); i++)
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                              for (int i = 1;
                                  i <= 5 - doc['rating'].round();
                                  i++)
                                const Icon(
                                  Icons.star_border,
                                  color: Colors.amber,
                                )
                            ],
                          ),
                    const Text(' | '),
                    Text(
                      'Order Success: ${doc['orderSuccess']}',
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 8,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[300],
          ),
          personalInfo(context, doc),
          Container(
            height: 8,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[300],
          ),
          certInfo(context, doc),
          Container(
            height: 8,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[300],
          ),
          serviceInfo(context, doc),
          Container(
            height: 8,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[300],
          ),
          contactInfo(context, doc),
          Container(
            height: 8,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[300],
          ),
          ratingInfo(context, doc),
          Container(
            height: 8,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[300],
          ),
          suggestedCl(context, doc),
        ],
      ),
    );
  }

  Widget personalInfo(BuildContext context, dynamic doc) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
          child: const Text(
            'Personal Information',
            style: TextStyle(fontSize: 17),
          ),
        ),
        const Divider(
          thickness: 0.5,
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Table(
            children: [
              TableRow(children: [
                const Text('Date of Birth'),
                Text(
                  DateFormat('yyyy-MM-dd').format(doc['dob'].toDate()),
                ),
              ]),
              const TableRow(children: [
                SizedBox(
                  height: 5,
                ),
                SizedBox(),
              ]),
              TableRow(children: [
                const Text('Vegetarian'),
                doc['vegan'] ? const Text('Yes') : const Text('No'),
              ]),
              const TableRow(children: [
                SizedBox(
                  height: 5,
                ),
                SizedBox(),
              ]),
              TableRow(children: [
                const Text('Race'),
                Text(doc['race']),
              ]),
              const TableRow(children: [
                SizedBox(
                  height: 5,
                ),
                SizedBox(),
              ]),
              TableRow(children: [
                const Text('Religion'),
                Text(doc['religion']),
              ]),
              const TableRow(children: [
                SizedBox(
                  height: 5,
                ),
                SizedBox(),
              ]),
              TableRow(children: [
                const Text('Nationality'),
                Text(doc['nationality']),
              ]),
              const TableRow(children: [
                SizedBox(
                  height: 5,
                ),
                SizedBox(),
              ]),
              TableRow(children: [
                const Text('Address'),
                Text(doc['detailAddress']),
              ]),
              const TableRow(children: [
                SizedBox(
                  height: 5,
                ),
                SizedBox(),
              ]),
              TableRow(children: [
                const Text('Postal Code'),
                Text(doc['postalCode']),
              ]),
              const TableRow(children: [
                SizedBox(
                  height: 5,
                ),
                SizedBox(),
              ]),
              TableRow(children: [
                const Text('Area, State'),
                Text(doc['stateArea']),
              ]),
              const TableRow(children: [
                SizedBox(
                  height: 5,
                ),
                SizedBox(),
              ]),
            ],
          ),
        )
      ],
    );
  }

  Widget contactInfo(BuildContext context, dynamic doc) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
          child: const Text(
            'Contact Information',
            style: TextStyle(fontSize: 17),
          ),
        ),
        const Divider(
          thickness: 0.5,
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Table(
            children: [
              TableRow(children: [
                const Text('Phone Number'),
                Text(doc['phone']),
              ]),
              const TableRow(children: [
                SizedBox(
                  height: 5,
                ),
                SizedBox(),
              ]),
              TableRow(children: [
                const Text('Email'),
                Text(doc['email']),
              ]),
              const TableRow(children: [
                SizedBox(
                  height: 5,
                ),
                SizedBox(),
              ]),
            ],
          ),
        )
      ],
    );
  }

  Widget serviceInfo(BuildContext context, dynamic doc) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
          child: const Text(
            'Service Variation',
            style: TextStyle(fontSize: 17),
          ),
        ),
        const Divider(
          thickness: 0.5,
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Table(
            children: const [
              TableRow(children: [
                Text('Basic'),
                SizedBox(),
              ]),
              TableRow(children: [
                SizedBox(
                  height: 5,
                ),
                SizedBox(),
              ]),
              TableRow(children: [
                Text('Premium'),
                SizedBox(),
              ]),
              TableRow(children: [
                SizedBox(
                  height: 5,
                ),
                SizedBox(),
              ]),
              TableRow(children: [
                Text('Deluxe'),
                SizedBox(),
              ]),
              TableRow(children: [
                SizedBox(
                  height: 5,
                ),
                SizedBox(),
              ]),
            ],
          ),
        )
      ],
    );
  }

  Widget ratingInfo(BuildContext context, dynamic doc) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Rating Review',
                style: TextStyle(fontSize: 17),
              ),
              doc['rating'] == 0
                  ? Row(
                      children: [
                        for (int i = 1; i <= 5; i++)
                          const Icon(
                            Icons.star_border,
                            color: Colors.amber,
                          )
                      ],
                    )
                  : Row(
                      children: [
                        for (int i = 1; i <= doc['rating'].round(); i++)
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 18,
                          ),
                        for (int i = 1; i <= 5 - doc['rating'].round(); i++)
                          const Icon(Icons.star_border,
                              color: Colors.amber, size: 18)
                      ],
                    ),
            ],
          ),
        ),
        const Divider(
          thickness: 0.5,
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: const Text('content'),
        )
      ],
    );
  }

  Widget certInfo(BuildContext context, dynamic doc) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
          child: const Text(
            'Certificate Obtain',
            style: TextStyle(fontSize: 17),
          ),
        ),
        const Divider(
          thickness: 0.5,
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
        )
      ],
    );
  }

  Widget suggestedCl(BuildContext context, dynamic doc) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
          child: const Text(
            'Similar Confinement Lady',
            style: TextStyle(fontSize: 17),
          ),
        ),
        const Divider(
          thickness: 0.5,
        ),
        StreamBuilder<QuerySnapshot>(
          stream: stream(doc),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Something went wrong"),
              );
            }

            if (snapshot.connectionState == ConnectionState.active) {
              final data = snapshot.data.docs;
              return Container(
                padding: const EdgeInsets.only(left: 8),
                height: 210,
                width: double.infinity,
                child: ListView.builder(
                  itemCount: data.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => Container(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      margin: const EdgeInsets.only(right: 25),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CLProfileDetail(id: data[index]['id']),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            CachedNetworkImage(
                              imageUrl: data[index]['imageUrl'],
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  ),
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator.adaptive(),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey,
                                child: Center(
                                  child: Icon(
                                    Icons.error,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                              height: 150,
                              width: MediaQuery.of(context).size.width * 0.4,
                            ),
                            const Spacer(),
                            Text(
                              data[index]['name'],
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }

            return const CircularProgressIndicator.adaptive();
          },
        )
      ],
    );
  }
}

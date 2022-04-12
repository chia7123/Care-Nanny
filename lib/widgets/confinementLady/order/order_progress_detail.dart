import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/widgets/open_google_map.dart';
import 'package:intl/intl.dart';

class CLProgressOrderDetail extends StatelessWidget {
  final String id;
  CLProgressOrderDetail(this.id, {Key key}) : super(key: key);

  var doc;

  Widget getTextWidgets(List<dynamic> strings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: strings
          .map(
            (item) => SizedBox(
              width: 200,
              child: Text(
                item,
                textAlign: TextAlign.end,
                softWrap: true,
              ),
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('onProgressOrder')
            .doc(id)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            final doc = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                title: const Text('Order Statement'),
                actions: [
                  openMap(
                    address: doc['cusAdd'],
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height ,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Customer Name : '),
                            Text(doc['cusName']),
                          ],
                        ),
                        Divider(
                          color: Colors.grey[500],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(
                                width: 150,
                                child: Text(
                                  'Customer Contact : ',
                                  softWrap: true,
                                )),
                            Text(doc['cusContact']),
                          ],
                        ),
                        Divider(
                          color: Colors.grey[500],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Customer Address : '),
                            SizedBox(
                              width: 150,
                              child: Text(
                                doc['cusAdd'],
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.grey[500],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Confinement Date : '),
                            SizedBox(
                              width: 120,
                              child: Text(
                                '${DateFormat.yMMMMd().format(doc['startDate'].toDate())} - ${DateFormat.yMMMMd().format(doc['endDate'].toDate())}',
                                textAlign: TextAlign.right,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.grey[500],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Service Package : '),
                            Text(doc['typeOfService']),
                          ],
                        ),
                        Divider(
                          color: Colors.grey[500],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Service Selected : '),
                            getTextWidgets(doc['serviceSelected']),
                          ],
                        ),
                        Divider(
                          color: Colors.grey[500],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Confinement Lady : '),
                            Text(doc['clName']),
                          ],
                        ),
                        Divider(
                          color: Colors.grey[500],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Ordered on : '),
                            Text(DateFormat.yMMMMd()
                                .add_jms()
                                .format(doc['creationDate'].toDate())),
                          ],
                        ),
                        const Divider(
                          thickness: 2,
                          color: Colors.black,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Price : ',
                              style: TextStyle(fontSize: 22),
                            ),
                            Text(
                              'RM ' + doc['price'].toStringAsFixed(2),
                              style: const TextStyle(fontSize: 22),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const Text('error');
          }
        });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2/widgets/customer/order/pending_order_buttons.dart';
import 'package:intl/intl.dart';

import '../../../service/database.dart';

class CusPendingOrderDetail extends StatelessWidget {
  final String id;

  const CusPendingOrderDetail(this.id, {Key key}) : super(key: key);

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Order'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('onPendingOrder')
            .doc(id)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            final doc = snapshot.data;
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  elevation: 20,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Order Statement',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  decorationStyle: TextDecorationStyle.double),
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Customer Name : '),
                                    Text(doc['cusName']),
                                  ],
                                ),
                                Divider(
                                  color: Colors.grey[500],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Customer Address : '),
                                    SizedBox(
                                      width: 180,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Service Package : '),
                                    Text(doc['typeOfService']),
                                  ],
                                ),
                                Divider(
                                  color: Colors.grey[500],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Service Selected : '),
                                    getTextWidgets(doc['serviceSelected']),
                                  ],
                                ),
                                Divider(
                                  color: Colors.grey[500],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Confinement Lady : '),
                                    Text(doc['clName']),
                                  ],
                                ),
                                Divider(
                                  color: Colors.grey[500],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(
                                        width: 150,
                                        child: Text(
                                          'Confinement Lady Contact : ',
                                          softWrap: true,
                                        )),
                                    Text(doc['clContact']),
                                  ],
                                ),
                                Divider(
                                  color: Colors.grey[500],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Ordered on : '),
                                    Text(DateFormat.yMMMMd()
                                        .add_jms()
                                        .format(doc['creationDate'].toDate())),
                                  ],
                                ),
                              ],
                            ),
                          ),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red[600],
                      minimumSize: const Size.fromHeight(40),
                    ),
                    icon: const Icon(
                      Icons.cancel,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Future.delayed(const Duration(seconds: 1), () {
                        deleteOrder(doc['orderID']);
                        Navigator.pop(context);
                      });
                    },
                    label: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                )
              ],
            );
          } else {
            return const Text('error');
          }
        },
      ),
    );
  }

  Future<void> deleteOrder(String id) {
    return Database()
        .deletePendingOrder(id)
        .then((val) { 
          Fluttertoast.showToast(msg: 'Order Cancelled !');})
        .catchError((error) =>
            Fluttertoast.showToast(msg: "Failed to cancel order: $error"));
  }
}

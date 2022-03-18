import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class CLPendingOrderDetail extends StatelessWidget {
  final String id;

  CLPendingOrderDetail(this.id, {Key key}) : super(key: key);

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

  Future<void> declineOrder(String id) {
    return FirebaseFirestore.instance
        .collection('onPendingOrder')
        .doc(id)
        .delete()
        .then((value) => Fluttertoast.showToast(msg: 'Order Declined'))
        .catchError((error) =>
            Fluttertoast.showToast(msg: "Failed to delete user: $error"));
  }

  Future<void> acceptOrder(String id, BuildContext context) {
    return FirebaseFirestore.instance
        .collection('onPendingOrder')
        .doc(id)
        .get()
        .then((doc) {
      FirebaseFirestore.instance
          .collection('onProgressOrder')
          .doc(id)
          .set(doc.data());
    }).whenComplete(() {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Order Accepted');
      Future.delayed(const Duration(seconds: 1), () {
        FirebaseFirestore.instance
            .collection('onPendingOrder')
            .doc(id)
            .delete();
      });
    });
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
                const Divider(
                  thickness: 3,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton.icon(
                      icon: Icon(Icons.cancel, color: Colors.red[600]),
                      onPressed: () {
                        Navigator.pop(context);
                        Future.delayed(const Duration(seconds: 1), () {
                          declineOrder(doc['orderID']);
                        });
                      },
                      label: Text(
                        'Decline Order',
                        style: TextStyle(color: Colors.red[600]),
                      ),
                    ),
                    TextButton.icon(
                      icon: Icon(Icons.check, color: Colors.red[600]),
                      onPressed: () {
                        acceptOrder(doc['orderID'], context);
                      },
                      label: Text(
                        'Accept Order',
                        style: TextStyle(color: Colors.red[600]),
                      ),
                    ),
                  ],
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
}

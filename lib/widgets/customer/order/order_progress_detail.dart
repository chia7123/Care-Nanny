import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2/service/database.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CusProgressOrderDetail extends StatefulWidget {
  final String id;

  CusProgressOrderDetail(this.id, {Key key}) : super(key: key);

  @override
  _CusProgressOrderDetailState createState() => _CusProgressOrderDetailState();
}

class _CusProgressOrderDetailState extends State<CusProgressOrderDetail> {
  double ratings = 0;
  TextEditingController comment = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

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

  Future<void> deleteOrder(String id) {
    return Database()
        .deleteProgressOrder(id)
        .then((value) => Fluttertoast.showToast(msg: "Order Completed"))
        .catchError((error) =>
            Fluttertoast.showToast(msg: "Failed to complete order: $error"));
  }

  Future<void> completeOrder(String id, double ratingGiven) {
    return Database().getProgressOrder(id).then((doc) {
      Database().addOrderHistory(
        'customerOrderHistory',
        id,
        doc.data(),
      );
      Database().addRating(
        'customerOrderHistory',
        id,
        {
          'ratingGiven': ratingGiven,
          'comment': comment.text,
        },
      );
      Database().addOrderHistory(
        'CLOrderHistory',
        id,
        doc.data(),
      );
      Database().addRating(
        'CLOrderHistory',
        id,
        {
          'ratingGiven': ratingGiven,
          'comment': comment.text,
        },
      );
      

      Future.delayed(const Duration(seconds: 1), () {
        deleteOrder(id);
      });
    });
  }

  void showDialog(BuildContext context, String clName, String clID,
      String orderID, String cusName, String cusContact) {
    Alert(
        context: context,
        title: 'Give ' + clName + ' a rating',
        content: Column(
          children: <Widget>[
            RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                ratings = rating;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.only(left: 10),
              child: TextFormField(
                minLines: 6,
                keyboardType: TextInputType.multiline,
                maxLines: 8,
                decoration: const InputDecoration(
                  hintText: 'Comment...',
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                controller: comment,
              ),
            )
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              calculateRating(clID, ratings, orderID, cusName, cusContact);
              completeOrder(orderID, ratings);
              Navigator.pop(context);
              Navigator.pop(context);
              Fluttertoast.showToast(msg: 'Completed');
            },
            child: const Text(
              "Submit",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  void calculateRating(String clID, double rating, String orderID,
      String cusName, String cusContact) async {
    double oriRating;
    int noOfOrder;
    double latestRating;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(clID)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> doc = documentSnapshot.data();
        oriRating = doc['rating'].toDouble();
        noOfOrder = doc['orderSuccess'];
      } else {
        return null;
      }
    });

    latestRating = (oriRating * noOfOrder + rating) / ++noOfOrder;
    FirebaseFirestore.instance.collection('users').doc(clID).update({
      'orderSuccess': noOfOrder,
      'rating': latestRating,
    });

    print(latestRating);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Order'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('onProgressOrder')
            .doc(widget.id)
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
                                    Text(DateFormat.yMMMMd()
                                        .format(doc['selectedDate'].toDate())),
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
                                    const Text('Ordered by : '),
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
                        Navigator.of(context).pop();
                        Future.delayed(const Duration(seconds: 1), () {
                          deleteOrder(doc['orderID']);
                        });
                        Fluttertoast.showToast(msg: 'Deleted');
                      },
                      label: Text(
                        'Cancel Order',
                        style: TextStyle(color: Colors.red[600]),
                      ),
                    ),
                    TextButton.icon(
                      icon: Icon(Icons.check, color: Colors.red[600]),
                      onPressed: () {
                        showDialog(context, doc['clName'], doc['clID'],
                            doc['orderID'], doc['cusName'], doc['cusContact']);
                      },
                      label: Text(
                        'Order Complete',
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

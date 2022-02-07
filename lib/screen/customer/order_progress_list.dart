import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2/service/database.dart';
import 'package:fyp2/widgets/customer/order/order_progress_detail.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CusProgressOrderList extends StatefulWidget {
  static const routeName = '/order';

  @override
  _CusProgressOrderListState createState() => _CusProgressOrderListState();
}

class _CusProgressOrderListState extends State<CusProgressOrderList> {
  final user = FirebaseAuth.instance.currentUser;

  double ratings = 0;
  TextEditingController comment = TextEditingController();

  @override
  void initState() {
    super.initState();
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

  void showDialog(
    BuildContext context,
    String clName,
    String clID,
    String orderID,
    String cusName,
    String cusContact,
  ) {
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
              Fluttertoast.showToast(msg: 'Completed');
            },
            child: const Text(
              "Submit",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  void calculateRating(
    String clID,
    double rating,
    String orderID,
    String cusName,
    String cusContact,
  ) async {
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('onProgressOrder')
            .where('cusID', isEqualTo: user.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.isEmpty) {
              return const Center(
                child: Text('No Progress Order Yet'),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                final doc = snapshot.data.docs[index];
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            CusProgressOrderDetail(doc['orderID']),
                      ),
                    );
                  },
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton.icon(
                                icon:
                                    Icon(Icons.cancel, color: Colors.red[600]),
                                onPressed: () {
                                  Future.delayed(const Duration(seconds: 1),
                                      () {
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
                                icon: Icon(
                                  Icons.check,
                                  color: Colors.red[600],
                                ),
                                onPressed: () {
                                  showDialog(
                                      context,
                                      doc['clName'],
                                      doc['clID'],
                                      doc['orderID'],
                                      doc['cusName'],
                                      doc['cusContact']);
                                },
                                label: Text(
                                  'Order Complete',
                                  style: TextStyle(color: Colors.red[600]),
                                ),
                              ),
                            ],
                          )
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
            return const Text('no data');
          }
        },
      ),
    );
  }
}

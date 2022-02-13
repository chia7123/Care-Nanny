import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2/service/database.dart';
import 'package:fyp2/service/date_range_picker_extend.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class OrderButtons extends StatelessWidget {
  final dynamic doc;
  final TextEditingController comment;
  OrderButtons({Key key, this.doc, this.comment}) : super(key: key);

  double ratings = 0;

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
  }

  Future<void> deleteOrder(String id) {
    return Database()
        .deleteProgressOrder(id)
        .then((value) => Fluttertoast.showToast(msg: "Order Completed"))
        .catchError((error) =>
            Fluttertoast.showToast(msg: "Failed to complete order: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton.icon(
          icon: Icon(Icons.cancel, color: Colors.red[600],size: 20,),
          onPressed: () {
            Future.delayed(const Duration(seconds: 1), () {
              deleteOrder(doc['orderID']);
            });

            Fluttertoast.showToast(msg: 'Deleted');
          },
          label: Text(
            'Cancel',
            style: TextStyle(color: Colors.red[600],fontSize: 15),
          ),
        ),
        TextButton.icon(
          icon: const Icon(
            Icons.date_range,
            color: Colors.blue,
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => DateRangePickerExtend(
                      orderID: doc['orderID'],
                    )));
          },
          label: const Text(
            'Extend',
            style: TextStyle(color: Colors.blue),
          ),
        ),
        TextButton.icon(
          icon: const Icon(
            Icons.check,
            color: Colors.green,
          ),
          onPressed: () {
            showDialog(
              context,
              doc['clName'],
              doc['clID'],
              doc['orderID'],
              doc['cusName'],
              doc['cusContact'],
            );
          },
          label: const Text(
            'Complete',
            style: TextStyle(color: Colors.green),
          ),
        ),
      ],
    );
  }
}

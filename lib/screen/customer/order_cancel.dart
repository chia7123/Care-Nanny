import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../service/database.dart';
import '../info_page.dart';

class CancelOrder extends StatelessWidget {
  CancelOrder({Key key, this.doc}) : super(key: key);
  final dynamic doc;

  TextEditingController desc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Cancel Order'),
          ),
          body: Column(
            children: [
              Expanded(
                child: SizedBox(
                  child: content(context),
                ),
              ),
              Container(
                height: 8,
                width: MediaQuery.of(context).size.width,
                color: Colors.grey[300],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => submit(context, doc),
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  child: const Text('Submit'),
                ),
              )
            ],
          )),
    );
  }

  Widget content(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 16, 0, 16),
            child: Text(
              'Cancel Order Detail',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Container(
            height: 8,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[300],
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 8, 0, 0),
            child: Text(
              'Confinement Package',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  doc['typeOfService'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 15,
                  ),
                ),
                Text(
                  'RM ${doc['price'].toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 8,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[300],
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 8, 0, 0),
            child: Text(
              'Services Included',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          Container(
            height: 180,
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: ListView.builder(
              itemCount: doc['serviceSelected'].length,
              itemBuilder: (context, index) =>
                  Text(doc['serviceSelected'][index]),
            ),
          ),
          Container(
            height: 8,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[300],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Description',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Please provide a proper reason to cancel the order.',
                  style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 14,
                      color: Colors.grey),
                )
              ],
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: TextField(
              controller: desc,
              decoration: const InputDecoration(
                  hintText: 'Cancel Reason... (Required)',
                  border: InputBorder.none),
            ),
          ),
        ],
      ),
    );
  }

  submit(BuildContext context, dynamic doc) {
    if (desc.text.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please provide the reason to cancel the order.');
      return;
    }
    Database().getPendingOrder(doc['orderID']).then((doc) async {
      await FirebaseFirestore.instance
          .collection('cancelOrder')
          .doc(doc['orderID'])
          .set(doc.data());
      await FirebaseFirestore.instance
          .collection('cancelOrder')
          .doc(doc['orderID'])
          .update({
        'cancelReason': desc.text,
        'status': 'pending',
      }).whenComplete(() {
        String msg = 'Your order had been cancelled.';
        
        Future.delayed(const Duration(seconds: 1), () {
          deleteOrder(doc['orderID']);
        }).then((value) => {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InfoPage(
                      msg: msg,
                      color: Colors.red,
                      imgUrl: 'assets/images/cross.png',
                    ),
                  ))
            });
      });
    });
  }

  Future<void> deleteOrder(String id) {
    return Database().deletePendingOrder(id).catchError((error) =>
        Fluttertoast.showToast(msg: "Failed to cancel order: $error"));
  }
}

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2/service/database.dart';

class PendingOrderButtons extends StatelessWidget {
  final doc;
  const PendingOrderButtons({Key key, this.doc}) : super(key: key);

  Future<void> deleteOrder(String id) {
    return Database()
        .deletePendingOrder(id)
        .then((val) { 
          Fluttertoast.showToast(msg: 'Order Cancelled !');})
        .catchError((error) =>
            Fluttertoast.showToast(msg: "Failed to cancel order: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
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
        Navigator.of(context).pop();
        Future.delayed(const Duration(seconds: 1), () {
          
          deleteOrder(doc['orderID']);
        });
      },
      label: const Text(
        'Cancel',
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
    );
  }
}

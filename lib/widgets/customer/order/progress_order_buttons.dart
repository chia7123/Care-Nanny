
import 'package:flutter/material.dart';
import 'package:fyp2/screen/customer/order_extend.dart';
import 'package:fyp2/screen/customer/order_rating.dart';

class ProgressOrderButtons extends StatelessWidget {
  final dynamic doc;
  ProgressOrderButtons({Key key, this.doc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            minimumSize: const Size.fromHeight(40),
          ),
          icon: const Icon(
            Icons.date_range,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ExtendOrder(
                  doc: doc,
                ),
              ),
            );
          },
          label: const Text(
            'Extend',
            style: TextStyle(color: Colors.white),
          ),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
            minimumSize: const Size.fromHeight(40),
          ),
          icon: const Icon(
            Icons.check,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RatingOrder(
                  doc: doc,
                ),
              ),
            );
          },
          label: const Text(
            'Complete',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

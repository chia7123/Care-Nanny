import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp2/screen/confirmation_page.dart';
import 'package:fyp2/screen/customer/get_nearest_cl.dart';
import 'package:fyp2/screen/order_process.dart';
import 'package:google_fonts/google_fonts.dart';

import 'order_history_list.dart';
import 'order_tab.dart';
import 'service_detail.dart';

class CustomerHome extends StatelessWidget {
  static const routeName = '/customerHomeScreen';
  CustomerHome({Key key}) : super(key: key);

  CollectionReference orderInfo =
      FirebaseFirestore.instance.collection('orderInfo');
  final user = FirebaseAuth.instance.currentUser;

  Widget actionButton(
      IconData icon, String label, Color color, void Function() callback) {
    return Column(
      children: <Widget>[
        ElevatedButton(
            onPressed: callback,
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: const CircleBorder(),
                primary: color),
            child: Container(
              width: 70.0,
              height: 70.0,
              alignment: Alignment.center,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: Icon(
                icon,
                size: 28.0,
                color: Colors.white,
              ),
            )),
        Container(
          margin: const EdgeInsets.only(top: 8.0),
          child: Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.black,
                  fontFamily: "MazzardH-SemiBold",
                  fontSize: 12.0,
                  height: 1.2)),
        )
      ],
    );
  }

  Widget quickAction(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.fromLTRB(25.0, 15.0, 25.0, 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              actionButton(Icons.shopping_cart, "Order Now", Colors.blueAccent,
                  () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderProcess(),
                    ));
              }),
              actionButton(Icons.assignment, "Orders", Colors.orangeAccent, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderTabScreen(index: 2),
                  ),
                );
              }),
              actionButton(Icons.history, "Order History", Colors.green, () {
                Navigator.pushNamed(context, CusOrderHistoryList.routeName);
              })
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('CareNanny', style: GoogleFonts.allura(fontSize: 35)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/logo.png'),
          ),
        ),
        child: Column(
          children: [
            quickAction(context),
            actionButton(Icons.gps_fixed, 'Scan', Colors.red, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GetNearestCL(),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}

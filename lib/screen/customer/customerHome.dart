import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp2/screen/customer/serviceDetail.dart';
import 'package:fyp2/service/database.dart';
import 'package:fyp2/service/generateID.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomerHome extends StatelessWidget {

  static const routeName = '/customerHomeScreen';
  CollectionReference orderInfo =
      FirebaseFirestore.instance.collection('orderInfo');
  final user = FirebaseAuth.instance.currentUser;
  String cusName;
  String add;
  String contact;
  String orderID = GenerateID().generateID(20);

  Future getCusInfo() async {
    final doc = await Database().getUserData(user.uid);

    cusName = doc['name'];
    add = doc['address1'] + '' + doc['address2'] + '' + doc['address3'];
    contact = doc['phone'];
  }

  Future<void> initializeOrder(BuildContext ctx) async {
    await getCusInfo();

    return Database().addOrder(orderID, {
      'orderID': orderID,
      'cusID': user.uid,
      'cusName': cusName,
      'cusContact': contact,
      'creationDate': DateTime.now(),
      'cusAdd': add,
      'clID': '',
      'clName': null,
      'price': null,
      'selectedDate': null,
      'serviceSelected': null,
      'typeOfService': 'Not selected yet',
    });
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
                initializeOrder(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ServiceDetailScreen(
                              orderID: orderID,
                            )));
              }),
              actionButton(Icons.assignment, "Orders", Colors.orangeAccent, () {
                // Navigator.pushNamed(context, OrderTabScreen.routeName);
              }),
              actionButton(Icons.history, "Order History", Colors.green, () {
                // Navigator.pushNamed(context, CusOrderHistory.routeName);
              })
            ],
          ),
        )
      ],
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('CareNanny', style: GoogleFonts.allura(fontSize: 35)),
        backgroundColor: Theme.of(context).primaryColor,
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
          ],
        ),
      ),
    );
  }
}

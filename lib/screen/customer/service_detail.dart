import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2/service/database.dart';
import 'package:fyp2/widgets/customer/order/cl_list.dart';
import 'package:fyp2/widgets/customer/order/service_type.dart';
import 'package:intl/intl.dart';

class ServiceDetailScreen extends StatefulWidget {
  static const routeName = '/servicedetail';
  final String orderID;

  const ServiceDetailScreen({Key key, this.orderID}) : super(key: key);

  @override
  _ServiceDetailScreenState createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  FToast fToast;
  final user = FirebaseAuth.instance.currentUser;
  DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    Database().deleteOrder(widget.orderID);
    super.dispose();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    ).then((pickedDate) {
      if (pickedDate == null) {
        Fluttertoast.showToast(msg: 'Date not selected');
        return null;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
      addDate();
    });
  }

  Future<void> addDate() {
    if (_selectedDate == null) {
      return null;
    }
    return Database().updateOrderData(widget.orderID, {
      'selectedDate': _selectedDate,
    });
  }

  Future<void> checkout(String orderID) {
    if (_selectedDate == null) {
      return null;
    }

    return Database().getOrderData(orderID).then((DocumentSnapshot snapshot) {
      Map<String, dynamic> doc = snapshot.data();
      Database().addPendingOrder(orderID, doc);
    }).whenComplete(() {
      Fluttertoast.showToast(
          msg: 'Order Placed Successfully, Pending for Confirmation Now');
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confinement Service Detail'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Choose Your Confinement Lady',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ConLadyList(widget.orderID)));
                            },
                            child: const Text('Press here'),
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor,
                              onPrimary: Colors.white,
                            )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Choose Your Confinement Service',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ServiceType(widget.orderID)));
                            },
                            child: const Text('Press here'),
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor,
                              onPrimary: Colors.white,
                            )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Choose Your Confinement Date',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              _presentDatePicker();
                            },
                            child: const Text('Press here'),
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor,
                              onPrimary: Colors.white,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('orderInfo')
                    .doc(widget.orderID)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.data.exists) {
                    return const CircularProgressIndicator(
                      strokeWidth: 5,
                    );
                  }
                  if (snapshot.hasData) {
                    final doc = snapshot.data;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.all(10),
                          height: MediaQuery.of(context).size.height * 0.43,
                          child: Column(children: [
                            const Text(
                              'Order Detail',
                              style: TextStyle(
                                  fontSize: 20,
                                  decoration: TextDecoration.underline),
                            ),
                            Expanded(
                              flex: 3,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Confinnement lady:'),
                                  doc['clName'] == null
                                      ? const Text('Not selected yet')
                                      : Text(doc['clName']),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Service Selected:'),
                                  doc['typeOfService'] == null
                                      ? const Text('Not selected yet')
                                      : Text(
                                          doc['typeOfService'],
                                          softWrap: true,
                                        ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Confinement Date:'),
                                  doc['selectedDate'] == null
                                      ? const Text('Not selected yet')
                                      : Text(DateFormat.yMMMMd().format(
                                          doc['selectedDate'].toDate())),
                                ],
                              ),
                            ),
                            const Divider(
                              color: Colors.black,
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Price:',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  doc['price'] == null
                                      ? const Text(
                                          'RM 0.00',
                                          style: TextStyle(fontSize: 20),
                                        )
                                      : Text(
                                          'RM ' +
                                              doc['price'].toStringAsFixed(2),
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                ],
                              ),
                            ),
                          ]),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: RaisedButton.icon(
                              icon: const Icon(
                                Icons.shopping_cart,
                                color: Colors.white,
                              ),
                              color: Theme.of(context).primaryColor,
                              onPressed: () => checkout(doc['orderID']),
                              label: const Text(
                                'Checkout',
                                style: TextStyle(color: Colors.white),
                              )),
                        )
                      ],
                    );
                  } else {
                    return const Text('no data');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

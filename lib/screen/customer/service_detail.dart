import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2/service/database.dart';
import 'package:fyp2/service/date_range_picker.dart';
import 'package:fyp2/service/generate_id.dart';
import 'package:fyp2/widgets/customer/order/cl_list.dart';
import 'package:fyp2/widgets/customer/order/service_type.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ServiceDetailScreen extends StatefulWidget {
  static const routeName = '/servicedetail';
  ServiceDetailScreen({Key key}) : super(key: key);

  @override
  _ServiceDetailScreenState createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  final user = FirebaseAuth.instance.currentUser;
  String cusName;
  String address;
  String contact;
  String orderID;
  String clID;
  String clName;

  Future getInfo() async {
    final doc = await Database().getUserData(user.uid);

    cusName = doc['name'];
    address = doc['address1'] + '' + doc['address2'] + '' + doc['address3'];
    contact = doc['phone'];

    await FirebaseFirestore.instance
        .collection('tempData')
        .get()
        .then((QuerySnapshot snapshot) => {
              if (snapshot.docs.isNotEmpty)
                {
                  clID = snapshot.docs[0]['id'],
                  clName = snapshot.docs[0]['name'],
                }
            });
  }

  void initializeOrder() async {
    orderID = GenerateID().generateID(20);

    await getInfo();

    await Database().addOrder(orderID, {
      'orderID': orderID,
      'cusID': user.uid,
      'cusName': cusName,
      'cusContact': contact,
      'creationDate': DateTime.now(),
      'cusAdd': address,
      'clID': '',
      'clName': clName,
      'price': null,
      'startDate': null,
      'endDate': null,
      'serviceSelected': null,
      'typeOfService': 'Not selected yet',
    });
  }

  @override
  void initState() {
    initializeOrder();
    super.initState();
  }

  @override
  void dispose() {
    Database().deleteOrder(orderID);
    Database().deleteTempData();
    super.dispose();
  }

  Future<void> checkout(String orderID) async {
    await Database().getOrderData(orderID).then((DocumentSnapshot snapshot) {
      Map<String, dynamic> doc = snapshot.data();

      if (doc['startDate'] == null) {
        Fluttertoast.showToast(msg: 'Please select the confinement date');
        return null;
      } else {
        Database().addPendingOrder(orderID, doc);
        Fluttertoast.showToast(
            msg: 'Order Placed Successfully, Pending for Confirmation Now');
        Database().deleteTempData();
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confinement Service Detail'),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.20,
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
                                  builder: (context) => ConLadyList(orderID)));
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
                                  builder: (context) => ServiceType(orderID)));
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
                              Database()
                                  .getOrderData(orderID)
                                  .then((DocumentSnapshot snapshot) {
                                Map<String, dynamic> doc = snapshot.data();
                                if (doc['clID'] == '') {
                                  Fluttertoast.showToast(
                                      msg:
                                          'Please choose Confinement Lady first !');
                                } else {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => DateRangePicker(
                                            orderID: orderID,
                                            clId: doc['ID'],
                                          )));
                                }
                              });
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('orderInfo')
                    .doc(orderID)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData) {
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
                                  doc['startDate'] == null
                                      ? const Text('Not selected yet')
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${DateFormat.yMMMMd().format(doc['startDate'].toDate())} - ',
                                            ),
                                            Text(
                                              DateFormat.yMMMMd().format(
                                                  doc['endDate'].toDate()),
                                            ),
                                          ],
                                        ),
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
                    return const CircularProgressIndicator();
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

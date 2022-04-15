import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2/screen/info_page.dart';
import 'package:fyp2/screen/customer/service_select.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../service/database.dart';
import '../../service/date_range_picker_service.dart';
import '../../service/side_services.dart';
import '../../service/payment.dart';
import '../../widgets/customer/order/cl_list.dart';

class OrderProcess extends StatefulWidget {
  String clID;
  String clName;
  String imageUrl;

  OrderProcess({Key key, this.clID, this.clName, this.imageUrl})
      : super(key: key);

  @override
  State<OrderProcess> createState() => _OrderProcessState();
}

class _OrderProcessState extends State<OrderProcess> {
  final user = FirebaseAuth.instance.currentUser;
  String orderID;
  int _currentStep = 0;
  DocumentSnapshot<Map<String, dynamic>> clData;
  Map<String, dynamic> _package;
  DateTime _startDate;
  DateTime _endDate;
  String clID;
  String clName;
  String imageUrl;
  double price = 0;
  int _days = 0;
  double totalPrice = 0;

  @override
  void initState() {
    orderID = SideServices().generateID(20);
    clID = widget.clID;
    clName = widget.clName;
    imageUrl = widget.imageUrl;
    super.initState();
  }

  void _selectPackage(Map<String, dynamic> package) async {
    if (clID != null) {
      clData = await Database().getUserData(clID);
    }
    setState(() {
      _package = package;
    });
    price = _package['price'];
    totalPrice = price * _days;
  }

  void _selectDate(DateTime startDate, DateTime endDate, int days) {
    setState(() {
      _startDate = startDate;
      _endDate = endDate;
      _days = days;
    });
  }

  Widget getTextWidgets(List<dynamic> strings) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: strings
              .map(
                (item) => Text(item),
              )
              .toList(),
        ),
      ),
    );
  }

  void _checkDetail() {
    Alert(
      context: context,
      desc: 'RM ${_package['price'].toStringAsFixed(2)}\n(daily)',
      title: _package['typeOfService'],
      content: Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        decoration: BoxDecoration(
            border: Border.all(
          color: Colors.grey[300],
          width: 5,
        )),
        child: getTextWidgets(_package['serviceSelected']),
      ),
    ).show();
  }

  Future<void> checkout() async {
    final cusData = await Database().getUserData(user.uid);

    BraintreeDropInResult result =
        await Payment().paymentRequest(price: _package['price'] * _days);
    if (result != null) {
      Database().addPendingOrder(orderID, {
        'orderID': orderID,
        'cusID': user.uid,
        'cusName': cusData['name'],
        'cusContact': cusData['phone'],
        'creationDate': DateTime.now(),
        'cusAdd': cusData['detailAddress'] +
            ' ' +
            cusData['postalCode'] +
            ' ' +
            cusData['stateArea'],
        'clID': clID,
        'clName': clData['name'],
        'clContact': clData['phone'],
        'dailyPrice': price,
        'price': totalPrice,
        'totalDays': _days,
        'startDate': _startDate,
        'endDate': _endDate,
        'serviceSelected': _package['serviceSelected'],
        'typeOfService': _package['typeOfService'],
      });
      String msg = 'Your order had been placed successfully.';

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => InfoPage(
              color: Colors.green, imgUrl: 'assets/images/tick.png', msg: msg),
        ),
      );
    } else {
      Fluttertoast.showToast(msg: 'Plese make the payment first');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Place Your Order'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Stepper(
            steps: [
              Step(
                title: const Text(
                  'Select Confinement Lady',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    clID != null
                        ? Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            elevation: 10,
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(10),
                              leading: CachedNetworkImage(
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                imageUrl: imageUrl,
                                imageBuilder: (context, imageProvider) =>
                                    CircleAvatar(
                                  radius: 70,
                                  backgroundImage: imageProvider,
                                ),
                              ),
                              title: Text(
                                clName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        : const Text(
                            'No Confinement Lady Selected \nPlease Select One',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.start,
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ConLadyList(),
                          ),
                        );
                      },
                      child: const Text('Press here'),
                    ),
                  ],
                ),
              ),
              Step(
                title: const Text(
                  'Select Confinement Date',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _startDate != null
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Date selected : \n${DateFormat('yyyy-MM-dd').format(_startDate)} - ${DateFormat('yyyy-MM-dd').format(_endDate)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          )
                        : const Text(
                            'No Confinement Date Selected \nPlease Select Now',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.start,
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (clID == null) {
                            Fluttertoast.showToast(
                                msg: 'Please choose Confinement Lady first !');
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => DateRangePickerService(
                                      clId: clID,
                                      selectDateTime: _selectDate,
                                    )));
                          }
                        },
                        child: const Text('Press here'),
                       ),
                  ],
                ),
              ),
              Step(
                title: const Text(
                  'Select Confinement Package',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _package != null
                        ? Card(
                            elevation: 15,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            child: ListTile(
                              title: Text(
                                _package['typeOfService'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              onTap: () => _checkDetail(),
                            ),
                          )
                        : const Text(
                            'No Confinement Service Selected Yet \nPlease Select One',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.start,
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (clID == null || _days == null) {
                          Fluttertoast.showToast(
                              msg: 'Please choose Confinement Lady first !');
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ServiceSelect(
                                id: clID,
                                selectPackage: _selectPackage,
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text('Press here'),
                     
                    ),
                  ],
                ),
              ),
            ],
            currentStep: _currentStep,
            onStepTapped: (int index) {
              setState(() {
                _currentStep = index;
              });
            },
            onStepContinue: () {
              if (_currentStep == 2 &&
                  clID != null &&
                  _package != null &&
                  _startDate != null) {
                checkout();
              } else if (_currentStep == 2 &&
                  (clID == null || _package == null || _startDate == null)) {
                Fluttertoast.showToast(
                    msg: 'Please select all the required field first!');
              }
              if (_currentStep < 2) {
                setState(() {
                  ++_currentStep;
                });
              }
            },
            onStepCancel: () {
              switch (_currentStep) {
                case 0:
                  setState(() {
                    clID = null;
                    clName = null;
                    imageUrl = null;
                  });
                  break;
                case 1:
                  setState(() {
                    _currentStep--;
                    _startDate = null;
                    _endDate = null;
                  });
                  break;
                case 2:
                  setState(() {
                    _package = null;
                  });
                  break;
                default:
              }
            },
            elevation: 3,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Text(
                    'Total Price :',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text('(RM ${price.toStringAsFixed(2)} x $_days days)'),
                ],
              ),
              Text(
                'RM ${totalPrice.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

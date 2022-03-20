import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2/screen/confirmation_page.dart';
import 'package:fyp2/screen/customer/services_tab.dart';
import 'package:fyp2/widgets/profile_card.dart';
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

  @override
  void initState() {
    orderID = SideServices().generateID(20);
    clID = widget.clID;
    clName = widget.clName;
    imageUrl = widget.imageUrl;
    super.initState();
  }

  void _selectCL(String id) async {
    clData = await Database().getUserData(id);
    setState(() {
      clID = id;
      clName = clData['name'];
      imageUrl = clData['imageUrl'];
    });
  }

  void _selectPackage(Map<String, dynamic> package) async {
    setState(() {
      _package = package;
    });
    if (clID != null) {
      clData = await Database().getUserData(clID);
    }
  }

  void _selectDate(DateTime startDate, DateTime endDate) {
    setState(() {
      _startDate = startDate;
      _endDate = endDate;
    });
  }

  Widget getTextWidgets(List<dynamic> strings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: strings
          .map(
            (item) => Text(item),
          )
          .toList(),
    );
  }

  void _checkDetail() {
    Alert(
      context: context,
      desc: 'RM' + _package['price'].toString(),
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
        await Payment().paymentRequest(price: _package['price']);
    if (result != null) {
      Database().addPendingOrder(orderID, {
        'orderID': orderID,
        'cusID': user.uid,
        'cusName': cusData['name'],
        'cusContact': cusData['phone'],
        'creationDate': DateTime.now(),
        'cusAdd': cusData['address1'] +
            '' +
            cusData['address2'] +
            '' +
            cusData['address3'],
        'clID': clID,
        'clName': clData['name'],
        'clContact': clData['phone'],
        'price': _package['price'],
        'startDate': _startDate,
        'endDate': _endDate,
        'serviceSelected': _package['serviceSelected'],
        'typeOfService': _package['typeOfService'],
      });
      Fluttertoast.showToast(
          msg: 'Order Placed Successfully, Pending for Confirmation Now');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ConfirmationPage(),
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
      body: Stepper(
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
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: ProfileCard(clID),
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
                          builder: (context) => ConLadyList(
                            selectCL: _selectCL,
                          ),
                        ),
                      );
                    },
                    child: const Text('Press here'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                    )),
              ],
            ),
          ),
          Step(
            title: const Text(
              'Select Date of Confinement',
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
                      print(clID);
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
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                    )),
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
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => ServicesTab(
                                  orderID: orderID,
                                  selectPackage: _selectPackage,
                                )),
                      );
                    },
                    child: const Text('Press here'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                    ),
                  ),
                ],
              )),
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
                _currentStep--;
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
    );
  }
}

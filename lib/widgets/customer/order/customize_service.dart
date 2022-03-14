import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2/data/services_data.dart';
import 'package:fyp2/models/service.dart';

class CustomizePackage extends StatefulWidget {
  static const routeName = '/customizescreen';
  final Function(Map<String, dynamic> package) selectPackage;
  CustomizePackage({Key key, this.selectPackage})
      : super(key: key);

  @override
  _CustomizePackageState createState() => _CustomizePackageState();
}

class _CustomizePackageState extends State<CustomizePackage> {
  final List<Service> _typeService = serviceType;
  CollectionReference orderInfo =
      FirebaseFirestore.instance.collection('orderInfo');
  final user = FirebaseAuth.instance.currentUser;

  var serviceSelected = [];
  double totalPrice = 0;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _typeService.length; i++) {
      _typeService[i].value = false;
    }
  }

  void getCheckboxItems(int index) {
    if (_typeService[index].value == true) {
      serviceSelected.add(_typeService[index].name);
    }
    if (_typeService[index].value == false) {
      serviceSelected.remove(_typeService[index].name);
    }
  }

  void _calculatePrice(int index) {
    if (_typeService[index].value == true) {
      totalPrice = totalPrice + _typeService[index].price;
    }
    if (_typeService[index].value == false) {
      totalPrice = totalPrice - _typeService[index].price;
    }
  }

  Future<void> addCheckBoxItems() {
    if (serviceSelected.isEmpty) {
      Fluttertoast.showToast(msg: 'Please select at least one of the service');
      return null;
    }
    Fluttertoast.showToast(msg: 'Service added');
    Navigator.of(context).pop();
    return widget.selectPackage({
      'typeOfService': 'Customize Service Package',
      'serviceSelected': serviceSelected,
      'price': totalPrice,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              width: 2,
              style: BorderStyle.solid,
            ),
          ),
          height: MediaQuery.of(context).size.height * 0.56,
          child: Scrollbar(
            thickness: 5,
            radius: const Radius.circular(10),
            child: ListView.builder(
                itemCount: _typeService.length,
                itemBuilder: (_, index) {
                  return CheckboxListTile(
                    checkColor: Colors.white,
                    activeColor: Theme.of(context).primaryColor,
                    title: Text(_typeService[index].name),
                    subtitle: Text(
                      'RM ${_typeService[index].price.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    value: _typeService[index].value,
                    onChanged: (values) {
                      setState(() {
                        _typeService[index].value = values;
                        _calculatePrice(index);
                        getCheckboxItems(index);
                      });
                    },
                  );
                }),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 30.0),
              child: Text(
                'Total Price (RM):',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: Text(
                totalPrice.toStringAsFixed(2),
                style: const TextStyle(fontSize: 40),
              ),
            ),
          ],
        ),
        const Expanded(
          child: SizedBox(),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.06,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: addCheckBoxItems,
            child: const Text(
              'Add to Cart',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                onPrimary: Colors.black),
          ),
        ),
      ],
    );
  }
}

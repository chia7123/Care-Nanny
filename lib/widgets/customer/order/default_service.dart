import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2/data/services_data.dart';
import 'package:fyp2/models/service.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DefaultPackage extends StatelessWidget {
  static const routeName = '/defaultpackage';
  final Function(Map<String, dynamic> package) selectPackage;
  DefaultPackage({Key key, this.selectPackage}) : super(key: key);
  final user = FirebaseAuth.instance.currentUser;
  CollectionReference order =
      FirebaseFirestore.instance.collection('orderInfo');

  final List<ServicePackage> _defaultPackage = defaultPackage;

  Widget getTextWidgets(List<String> strings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: strings
          .map(
            (item) => Text(item),
          )
          .toList(),
    );
  }

  void _checkDetail(
      BuildContext context, String packageName, List detail, double price) {
    Alert(
        context: context,
        desc: 'RM' + price.toString(),
        title: packageName,
        content: Container(
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          decoration: BoxDecoration(
              border: Border.all(
            color: Colors.grey[300],
            width: 5,
          )),
          child: getTextWidgets(detail),
        ),
        buttons: [
          DialogButton(
            color: Theme.of(context).primaryColor,
            onPressed: () => addPackage(context, packageName, detail, price),
            child: const Text(
              " ORDER THIS",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ]).show();
  }

  void addPackage(
      BuildContext context, String packageName, List detail, double price) {
    selectPackage({
      'typeOfService': 'Default ' + packageName,
      'serviceSelected': detail,
      'price': price,
    });
    Fluttertoast.showToast(msg: 'Service added');
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(
          style: BorderStyle.none,
        ),
      ),
      child: ListView.builder(
          itemCount: _defaultPackage.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => _checkDetail(
                context,
                _defaultPackage[index].packageName,
                _defaultPackage[index].details,
                _defaultPackage[index].price,
              ),
              borderRadius: BorderRadius.circular(38),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _defaultPackage[index].colors.withOpacity(0.5),
                      _defaultPackage[index].colors,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(38),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        left: 30,
                        top: 30,
                        right: 30,
                        bottom: 20,
                      ),
                      child: Text(
                        _defaultPackage[index].packageName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text('RM '),
                        Text(
                          _defaultPackage[index].price.toString(),
                          style: const TextStyle(fontSize: 25),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}

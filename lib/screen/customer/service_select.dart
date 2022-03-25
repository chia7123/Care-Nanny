import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2/screen/customer/service_customize.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../models/service.dart';

class ServiceSelect extends StatelessWidget {
  ServiceSelect({Key key, this.id, this.selectPackage}) : super(key: key);
  final String id;
  final Function(Map<String, dynamic>) selectPackage;

  List<String> list = ['Basic', 'Premium', 'Deluxe'];
  List<Color> colors = [Colors.blue, Colors.green, Colors.yellow];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Please select your service'),
        ),
        body: packageType(context),
      ),
    );
  }

  Widget packageType(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 20),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              InkWell(
                onTap: () {
                  FirebaseFirestore.instance
                      .collection('service')
                      .doc(id)
                      .get()
                      .then((DocumentSnapshot snapshot) {
                    Map<String, dynamic> data = snapshot.data();

                    double totalPrice = 0;
                    List<String> strings = [];

                    for (var d in data[list[index].toLowerCase()]) {
                      totalPrice += double.parse(d['price']);
                    }

                    for (var d in data[list[index].toLowerCase()]) {
                      strings.add('• ${d['title']}');
                    }
                    _checkDetail(
                        context, '${list[index]} Package', totalPrice, strings);
                  });
                },
                borderRadius: BorderRadius.circular(38),
                child: Container(
                  height: 120,
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colors[index].withOpacity(0.5),
                        colors[index],
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(38),
                  ),
                  child: Center(
                    child: Text(
                      '${list[index]} Package',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 80,
              )
            ],
          );
        },
      ),
    );
  }

  _checkDetail(BuildContext context, String packageName, double price,
      List<String> strings) {
    Alert(
        context: context,
        desc: 'RM ${price.toStringAsFixed(2)}\n(daily)',
        title: packageName,
        content: Container(
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          decoration: BoxDecoration(
              border: Border.all(
            color: Colors.grey[300],
            width: 5,
          )),
          child: SizedBox(
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
          ),
        ),
        buttons: [
          DialogButton(
            color: Theme.of(context).primaryColor,
            onPressed: () => addPackage(context, packageName, strings, price),
            child: const Text(
              "ORDER THIS",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          DialogButton(
            color: Theme.of(context).primaryColor,
            onPressed: () {
              List<Service> serviceType = [];
              FirebaseFirestore.instance
                  .collection('service')
                  .doc(id)
                  .get()
                  .then((DocumentSnapshot snapshot) {
                Map<String, dynamic> data = snapshot.data();

                for (var d
                    in data[packageName.split(' ').first.toLowerCase()]) {
                  Service service = Service();
                  service.name = d['title'];
                  service.price = double.parse(d['price']);
                  serviceType.add(service);
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomizeService(
                      selectPackage: selectPackage,
                      serviceType: serviceType,
                      price: price,
                    ),
                  ),
                );
              });
            },
            child: const Text(
              "CUSTOMIZE",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ]).show();
  }

  addPackage(BuildContext context, String packageName, List<String> strings,
      double price) {
    selectPackage({
      'typeOfService': 'Default ' + packageName,
      'serviceSelected': strings,
      'price': price,
    });
    Fluttertoast.showToast(msg: 'Service added');
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }
}

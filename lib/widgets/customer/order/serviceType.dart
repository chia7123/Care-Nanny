import 'package:flutter/material.dart';
import 'package:fyp2/widgets/customer/order/defaultService.dart';

import 'customizeService.dart';

class ServiceType extends StatelessWidget {
  static const routeName = '/typeService';
  final String orderID;

  ServiceType(this.orderID, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Choose one',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                onPrimary: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DefaultPackage(orderID)));
              },
              icon: const Icon(Icons.select_all),
              label: const Text('Default Confinement Service Package'),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                onPrimary: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CustomizePackage(orderID)));
              },
              icon: const Icon(Icons.construction),
              label: const Text('Customize Confinement Service Package'),
            ),
          ],
        ),
      ),
    );
  }
}

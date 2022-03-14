import 'package:flutter/material.dart';
import 'package:fyp2/widgets/customer/order/customize_service.dart';
import 'package:fyp2/widgets/customer/order/default_service.dart';

class ServicesTab extends StatelessWidget {
  ServicesTab({Key key, this.orderID, this.selectPackage}) : super(key: key);
  String orderID;
  Function(Map<String, dynamic> package) selectPackage;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Please select your service'),
          bottom: const TabBar(
            labelColor: Colors.white,
            tabs: [
              Tab(child: Text('Default Service')),
              Tab(child: Text('Customize Service')),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            DefaultPackage(selectPackage: selectPackage,),
            CustomizePackage(selectPackage: selectPackage),
          ],
        ),
      ),
    );
  }
}

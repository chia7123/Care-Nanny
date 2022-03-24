import 'package:flutter/material.dart';
import 'package:fyp2/screen/confinementLady/service_basic.dart';
import 'package:fyp2/screen/confinementLady/service_deluxe.dart';
import 'package:fyp2/screen/confinementLady/service_premium.dart';

class ServicesTab extends StatelessWidget {
  const ServicesTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Add Service'),
            bottom: const TabBar(
              labelColor: Colors.white,
              isScrollable: true,
              tabs: [
                Tab(
                  text: 'Basic Package',
                ),
                Tab(
                  text: 'Premium Package',
                ),
                Tab(
                  text: 'Deluxe Package',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              BasicService(),
              PremiumService(),
              DeluxeService(),
            ],
          ),
        ),
      ),
    );
  }
}

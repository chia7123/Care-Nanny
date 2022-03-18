import 'package:flutter/material.dart';
import 'package:fyp2/screen/confinementLady/order_history_list.dart';
import 'package:fyp2/widgets/menu_widget.dart';

import 'order_pending_list.dart';
import 'order_progress_list.dart';

class OrderTabScreen extends StatelessWidget {
  OrderTabScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Orders'),
          leading: const MenuWidget(),
          bottom: const TabBar(
            labelColor: Colors.white,
            isScrollable: true,

            tabs: [
              Tab(
                icon: Icon(
                  Icons.pending,
                ),
                text: 'Pending Order',
              ),
              Tab(
                icon: Icon(Icons.access_time_rounded),
                text: 'Progress Order',
              ),
              Tab(
                icon: Icon(Icons.history),
                text: 'History Order',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CLPendingOrderList(),
            CLProgressOrderList(),
            CLOrderHistoryList(),
          ],
        ),
      ),
    );
  }
}

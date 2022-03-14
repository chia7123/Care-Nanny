import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/screen/customer/order_history_list.dart';

import 'order_pending_list.dart';
import 'order_progress_list.dart';

class OrderTabScreen extends StatelessWidget {
   OrderTabScreen({Key key, this.index}) : super(key: key);
  static const routeName = '/orderTabScreen';
  final int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        initialIndex: index,
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Orders'),
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
                  icon: Icon(Icons.drag_indicator),
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
              CusPendingOrderList(),
              CusProgressOrderList(),
              CusOrderHistoryList(),
            ],
          ),
        ),
      ),
    );
  }
}

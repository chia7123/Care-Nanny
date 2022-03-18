import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/menu_widget.dart';
import 'order_history_list.dart';
import 'order_pending_list.dart';
import 'order_progress_list.dart';

class CLHome extends StatelessWidget {

  Widget quickAction(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(25.0, 15.0, 25.0, 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          actionButton(Icons.timelapse, "Pending Order", Colors.blueAccent, () {
            Navigator.pushNamed(context, CLPendingOrderList.routeName);
          }),
          actionButton(
              Icons.assignment, "On Progress Order", Colors.orangeAccent, () {
            Navigator.pushNamed(context, CLProgressOrderList.routeName);
          }),
          actionButton(Icons.history, "Order History", Colors.green, () {
            Navigator.pushNamed(context, CLOrderHistoryList.routeName);
          })
        ],
      ),
    );
  }

  Widget actionButton(
      IconData icon, String label, Color color, void Function() callback) {
    return Column(
      children: <Widget>[
        ElevatedButton(
            onPressed: callback,
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: const CircleBorder(),
                primary: color),
            child: Container(
              width: 70.0,
              height: 70.0,
              alignment: Alignment.center,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: Icon(
                icon,
                size: 28.0,
                color: Colors.white,
              ),
            )),
        Container(
          margin: const EdgeInsets.only(top: 8.0),
          child: Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.black,
                  fontFamily: "MazzardH-SemiBold",
                  fontSize: 12.0,
                  height: 1.2)),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const MenuWidget(),
        toolbarHeight: 80,
        title: Text('CareNanny', style: GoogleFonts.allura(fontSize: 35)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
         decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/logo.png'),
          ),
        ),
        child: Column(
          children: [
            quickAction(context),
          ],
        ),
      ),
    );
  }
}

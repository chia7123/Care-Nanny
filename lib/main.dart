import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp2/screen/confinementLady/orderHistoryList.dart';
import 'package:fyp2/screen/confinementLady/orderPendingList.dart';
import 'package:fyp2/screen/confinementLady/orderProgressList.dart';
import 'package:fyp2/screen/customer/customerHome.dart';
import 'package:fyp2/screen/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fyp2/screen/wrapper.dart';

import 'screen/customer/orderHistoryList.dart';
import 'screen/customer/orderPendingList.dart';
import 'screen/customer/orderProgressList.dart';
import 'screen/customer/orderTab.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Final Year Project',
      theme: ThemeData(
        backgroundColor: const Color.fromRGBO(242, 118, 74, 1),
        primaryColor: const Color.fromRGBO(242, 118, 74, 1),
        canvasColor: const Color.fromRGBO(255, 241, 201, 1),
        primarySwatch: Colors.orange,
      ),
      home: SplashScreen(),
      routes: {
        Wrapper.routeName: (context) => Wrapper(),
        CustomerHome.routeName: (context) => CustomerHome(),
        OrderTabScreen.routeName: (context) => OrderTabScreen(),
        CusProgressOrderList.routeName: (context) => CusProgressOrderList(),
        CusPendingOrderList.routeName: (context) => CusPendingOrderList(),
        CusOrderHistoryList.routeName: (context) => CusOrderHistoryList(),
        CLOrderHistoryList.routeName: (context) => CLOrderHistoryList(),
        CLPendingOrderList.routeName: (context) => CLPendingOrderList(),
        CLProgressOrderList.routeName: (context) => CLProgressOrderList(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (_) => Wrapper());
      },
    );
  }
}

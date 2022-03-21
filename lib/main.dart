import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp2/screen/confinementLady/order_history_list.dart';
import 'package:fyp2/screen/confinementLady/order_pending_list.dart';
import 'package:fyp2/screen/confinementLady/order_progress_list.dart';
import 'package:fyp2/screen/customer/customer_home.dart';
import 'package:fyp2/screen/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fyp2/screen/wrapper.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screen/customer/order_history_list.dart';
import 'screen/customer/order_pending_list.dart';
import 'screen/customer/order_progress_list.dart';
import 'screen/customer/order_tab.dart';

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
        appBarTheme: AppBarTheme(
            toolbarHeight: 65,
            backgroundColor: Colors.blue[200],
            iconTheme: const IconThemeData(color: Colors.white),
            actionsIconTheme: const IconThemeData(color: Colors.white),
            titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20)),
        textTheme: TextTheme(
          bodyText1: GoogleFonts.roboto(fontWeight: FontWeight.bold),
          bodyText2: GoogleFonts.roboto(fontSize: 15),
          
        ),
        primaryColor: Colors.blue[200],
        canvasColor: Colors.white,
       
        primarySwatch: Colors.blue,
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

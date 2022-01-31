
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp2/screen/splash.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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

        routes: const {
          
        },
        onUnknownRoute: (settings) {
        },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2/screen/confinementLady/cl_side_nav.dart';
import 'package:fyp2/screen/customer/customer_side_nav.dart';
import 'package:fyp2/screen/personal_info.dart';
import 'package:fyp2/screen/welcome.dart';

class Wrapper extends StatelessWidget {
  static const routeName = '/welcome';
  DateTime currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    DateTime timeBackPressed = DateTime.now();
    return WillPopScope(
      child: child(context),
      onWillPop: onWillPop,
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      String msg = 'Press the back button to exit';
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: msg);
      return Future.value(false);
    }
    return Future.value(true);
  }

  Widget child(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
    
                    if (snapshot.data['name'] == null) {
                      return PersonalInfo(snapshot.data['email']);
                    }
    
                    if (snapshot.data['userType'] == 'Confinement Lady') {
                      return const CLSideNav();
                    } else if (snapshot.data['userType'] == 'New Mother') {
                      return const CustomerSideNav();
                    } else {
                      return const Text('Usertype no data');
                    }
                  },
                );
              } else if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              } else {
                return Welcome();
              }
            }),
      ),
    );
  }
}

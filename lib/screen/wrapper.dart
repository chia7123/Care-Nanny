import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/screen/customer/customer_tab.dart';
import 'package:fyp2/screen/personal_info.dart';
import 'package:fyp2/screen/welcome.dart';
import 'confinementLady/cl_tab.dart';

class Wrapper extends StatelessWidget {
  static const routeName = '/welcome';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: StreamBuilder<Object>(
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

                  if  (snapshot.data['name'] == null) {
                    return PersonalInfo(snapshot.data['email']);
                  } 

                  if (snapshot.data['userType'] == 'Confinement Lady') {
                    return CLTab();
                  } else if (snapshot.data['userType'] == 'Customer') {
                    return CustomerTab();
                  }
                  else {
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
    );
  }
}

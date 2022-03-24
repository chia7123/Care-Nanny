import 'package:age_calculator/age_calculator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/screen/confinementLady/services_tab.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../service/database.dart';
import '../../widgets/menu_widget.dart';

class CLHome extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;
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
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              final data = snapshot.data;
              updateDOB(data);
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, ${data['name']}',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ServicesTab(),
                              ),
                            );
                          },
                          child: const Text('Set Up Service Package'))
                    ],
                  ),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
          }),
    );
  }

  void updateDOB(doc) {
    var age = AgeCalculator.age(doc['dob'].toDate()).years;
    Database().updateUserData(user.uid, {'age': age});
  }
}

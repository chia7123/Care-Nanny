import 'package:age_calculator/age_calculator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ImageSlideshow(
                      width: double.infinity,
                      height: 150,
                      initialPage: 0,
                      indicatorColor: Colors.blue,
                      indicatorBackgroundColor: Colors.grey,
                      onPageChanged: (value) {
                        debugPrint('Page changed: $value');
                      },
                      autoPlayInterval: 5000,
                      isLoop: true,
                      children: [
                        Image.asset(
                          'assets/images/slides/m.png',
                          fit: BoxFit.cover,
                        ),
                        Image.asset(
                          'assets/images/slides/cl1.png',
                          fit: BoxFit.cover,
                        ),
                        
                      ],
                    ),
                    Padding(
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
                          Stack(
                            children: [
                              Container(
                                alignment: Alignment.topCenter,
                                height: 300,
                                child: FittedBox(
                                  child: Image.asset(
                                    'assets/images/image_1.jpg',
                                    height: 200,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                  bottom: 55,
                                  right: 70,
                                  child: FittedBox(
                                    child: Image.asset(
                                      'assets/images/arrow.jpg',
                                      height: 20,
                                    ),
                                    fit: BoxFit.cover,
                                  )),
                              Positioned(
                                  bottom: 60,
                                  left: 20,
                                  child: Text(
                                    'Start your service here',
                                    style: GoogleFonts.permanentMarker(
                                        fontSize: 20),
                                  )),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary:
                                            Theme.of(context).primaryColor),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ServicesTab(),
                                        ),
                                      );
                                    },
                                    child: const Text('Setup Packages')),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
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

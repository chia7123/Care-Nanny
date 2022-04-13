import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2/data/info_data.dart';
import 'package:fyp2/models/info.dart';
import 'package:fyp2/screen/customer/cl_detail.dart';
import 'package:fyp2/screen/customer/order_process.dart';
import 'package:fyp2/widgets/menu_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../service/database.dart';
import '../../service/location.dart';

class CustomerHome extends StatefulWidget {
  static const routeName = '/customerHomeScreen';

  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  final user = FirebaseAuth.instance.currentUser;

  final List<Info> _infos = infos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        centerTitle: true,
        title: Text(
          'CareNanny',
          style: GoogleFonts.allura(fontSize: 35),
        ),
        leading: const MenuWidget(),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              final data = snapshot.data;
              return SingleChildScrollView(
                child: Column(
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
                          'assets/images/slides/m1.png',
                          fit: BoxFit.cover,
                        ),
                        Image.asset(
                          'assets/images/slides/m2.png',
                          fit: BoxFit.cover,
                        ),
                        Image.asset(
                          'assets/images/slides/m3.png',
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
                            style: GoogleFonts.roboto(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                         
                          nearMe(context),
                          exploreMore(context),
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).primaryColor,
        label: const Text('Make Appointment'),
        icon: const Icon(
          Icons.add_to_photos,
        ),
        elevation: 10,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderProcess(),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _computeDistance();
    super.initState();
  }

  Widget orderNow(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color.fromARGB(255, 219, 217, 217),
      ),
      child: TextButton.icon(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderProcess(),
          ),
        ),
        icon: const Icon(
          Icons.wallet_travel,
          color: Colors.black,
        ),
        label: const Text(
          'Order Now',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Widget nearMe(BuildContext context) {
    return SizedBox(
      height: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'NEAR ME',
                style: GoogleFonts.mukta(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                width: 2,
              ),
              const Icon(Icons.location_on),
            ],
          ),
          clList(),
        ],
      ),
    );
  }

  Widget exploreMore(BuildContext context) {
    _infos.shuffle();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
      height: MediaQuery.of(context).size.height * 0.32,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EXPLORE MORE \u2192',
            style: GoogleFonts.mukta(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 1),
            height: 200,
            width: double.infinity,
            child: ListView.builder(
              itemCount: _infos.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Container(
                margin: const EdgeInsets.only(right: 25),
                child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () async {
                      var url = _infos[index].url;
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        final msg = 'Could not launch $url';
                        Fluttertoast.showToast(msg: msg);
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CachedNetworkImage(
                          imageUrl: _infos[index].imageUrl,
                          imageBuilder: (context, imageProvider) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ),
                            );
                          },
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey,
                            child: Center(
                                child: Icon(
                              Icons.error,
                              color: Colors.grey[800],
                            )),
                          ),
                          height: 150,
                          width: MediaQuery.of(context).size.width * 0.4,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          height: 45,
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Text(
                            _infos[index].title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            softWrap: true,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }

  _computeDistance() {
    double startLat;
    double startLng;

    Database().getUserData(user.uid).then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> userData = snapshot.data();
        startLat = userData['latitude'];
        startLng = userData['longitude'];
      }
    });

    FirebaseFirestore.instance
        .collection('users')
        .where('userType', isEqualTo: 'Confinement Lady')
        .orderBy('latitude')
        .get()
        .then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        double distance = double.parse(LocationService()
            .distance(startLat, startLng, doc['latitude'], doc['longitude'])
            .toStringAsFixed(2));

        Database().updateUserData(doc['id'], {'tempDistance': distance});
      }
    });
  }

  Widget clList() {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('users')
          .orderBy('tempDistance')
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final data = snapshot.data.docs;
          return SizedBox(
            height: 210,
            width: double.infinity,
            child: ListView.builder(
              itemCount: data.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Container(
                padding: const EdgeInsets.only(bottom: 10),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  margin: const EdgeInsets.only(right: 25),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CLProfileDetail(id: data[index]['id']),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl: data[index]['imageUrl'],
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey,
                            child: Center(
                              child: Icon(
                                Icons.error,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                          height: 150,
                          width: MediaQuery.of(context).size.width * 0.4,
                        ),
                        Text(
                          data[index]['name'],
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Spacer(),
                        Text(
                          'Within ${data[index]['tempDistance'].toString()}km',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return const Center(child: CircularProgressIndicator.adaptive());
      },
    );
  }
}

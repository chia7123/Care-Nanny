import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2/data/info_data.dart';
import 'package:fyp2/models/info.dart';
import 'package:fyp2/screen/customer/get_nearest_cl.dart';
import 'package:fyp2/screen/customer/order_process.dart';
import 'package:fyp2/widgets/menu_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'order_history_list.dart';
import 'order_tab.dart';

class CustomerHome extends StatelessWidget {
  static const routeName = '/customerHomeScreen';
  final user = FirebaseAuth.instance.currentUser;

  final List<Info> _infos = infos;

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

  Widget quickAction(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(25.0, 15.0, 25.0, 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          actionButton(Icons.shopping_cart, "Order Now", Colors.blueAccent, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderProcess(),
              ),
            );
          }),
          actionButton(Icons.assignment, "Orders", Colors.orangeAccent, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderTabScreen(),
              ),
            );
          }),
          actionButton(Icons.history, "Order History", Colors.green, () {
            Navigator.pushNamed(context, CusOrderHistoryList.routeName);
          })
        ],
      ),
    );
  }

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
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
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
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, \n${data['name']}',
                        style: GoogleFonts.roboto(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'ORDER NOW \u2192',
                        style: GoogleFonts.mukta(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: orderNow(context),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'FIND NEARBY CONFINEMENT LADY',
                        style: GoogleFonts.mukta(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: nearbyOrder(context),
                      ),
                      exploreMore(context),
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

  Widget nearbyOrder(BuildContext context) {
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
            builder: (_) => GetNearestCL(),
          ),
        ),
        icon: const Icon(
          Icons.location_on,
          color: Colors.black,
        ),
        label: const Text(
          'Nearby Confinement Lady',
          style: TextStyle(color: Colors.black),
        ),
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
            margin: const EdgeInsets.only(top: 10),
            height: 200,
            width: double.infinity,
            child: ListView.builder(
              itemCount: _infos.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Container(
                margin: const EdgeInsets.only(right: 20),
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
                          placeholder: (context, url) => Container(
                            child: const Center(
                              child: CircularProgressIndicator.adaptive(),
                            ),
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
                          width: 200,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          height: 45,
                          width: 200,
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
}

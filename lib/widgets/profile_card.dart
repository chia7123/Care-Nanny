import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/service/database.dart';
import 'package:fyp2/widgets/full_screen_image.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ProfileCard extends StatelessWidget {
  final String id;
  ProfileCard(this.id, {Key key}) : super(key: key);

  var alertStyle = AlertStyle(
    backgroundColor: const Color.fromRGBO(255, 241, 201, 1),
    animationType: AnimationType.grow,
    isCloseButton: false,
    isOverlayTapDismiss: true,
    animationDuration: const Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
      side: const BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: const TextStyle(
      color: Colors.black,
    ),
    alertAlignment: Alignment.center,
  );

  showDialog(BuildContext context) async {
    DocumentSnapshot doc = await Database().getUserData(id);

    Alert(
      context: context,
      style: alertStyle,
      title: 'PROFILE',
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.5,
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(doc['imageUrl']),
                ),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FullScreenImage(
                              imageUrl: doc['imageUrl'],
                            ))),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                doc['name'],
                style: const TextStyle(
                  fontSize: 30,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Table(
                columnWidths: const {
                  0: FixedColumnWidth(65),
                  1: FixedColumnWidth(70),
                  2: FixedColumnWidth(85),
                },
                children: [
                  TableRow(
                    children: [
                      const Text(
                        'Age: ',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const Text(
                        '30',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const Text(
                        'Order Taken: ',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        doc['orderSuccess'].toString(),
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),
                  TableRow(children: [
                    const Text(
                      'Location: ',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      doc['address3'],
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const Text(
                      'Rating: ',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      doc['rating'].toString(),
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ])
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'About',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                width: double.maxFinite,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade300),
                child: Text(
                  doc['description'],
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      buttons: [
        DialogButton(
          width: 80,
          child: const Text(
            "Close",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Theme.of(context).primaryColor,
          radius: BorderRadius.circular(50.0),
        ),
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.info_outline,
        color: Colors.grey,
      ),
      onPressed: () => showDialog(context),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../service/videos/video_player.dart';
import '../../../service/videos/video_widget.dart';
import '../../full_screen_image.dart';

class CLOrderHistoryDetail extends StatelessWidget {
  final String id;
  CLOrderHistoryDetail(this.id, {Key key}) : super(key: key);

  Widget getTextWidgets(List<dynamic> strings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: strings
          .map(
            (item) => SizedBox(
              width: 200,
              child: Text(
                item,
                textAlign: TextAlign.end,
                softWrap: true,
              ),
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Statement'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('CLOrderHistory')
            .doc(id)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            final doc = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Customer Name : '),
                        Text(doc['cusName']),
                      ],
                    ),
                    Divider(
                      color: Colors.grey[500],
                    ),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Customer Address : '),
                        SizedBox(
                          width: 180,
                          child: Text(
                            doc['cusAdd'],
                            textAlign: TextAlign.right,softWrap: true,
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey[500],
                    ),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Confinement Date : '),
                        SizedBox(
                          width: 120,
                          child: Text(
                            '${DateFormat.yMMMMd().format(doc['startDate'].toDate())} - ${DateFormat.yMMMMd().format(doc['endDate'].toDate())}',
                            textAlign: TextAlign.right,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey[500],
                    ),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Service Package : '),
                        Text(doc['typeOfService']),
                      ],
                    ),
                    Divider(
                      color: Colors.grey[500],
                    ),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Service Selected : '),
                        getTextWidgets(doc['serviceSelected']),
                      ],
                    ),
                    Divider(
                      color: Colors.grey[500],
                    ),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Confinement Lady : '),
                        Text(doc['clName']),
                      ],
                    ),
                    Divider(
                      color: Colors.grey[500],
                    ),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                            width: 150,
                            child: Text(
                              'Confinement Lady Contact Number : ',
                              softWrap: true,
                            )),
                        Text(doc['clContact']),
                      ],
                    ),
                    Divider(
                      color: Colors.grey[500],
                    ),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Ordered on : '),
                        Text(DateFormat.yMMMMd()
                            .add_jms()
                            .format(doc['creationDate'].toDate())),
                      ],
                    ),
                    Divider(
                      color: Colors.grey[500],
                    ),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Rating Given : '),
                        Text(doc['rating'].toString()),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            for (int i = 1;
                                i <= doc['rating'].round();
                                i++)
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 30,
                              )
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey[500],
                    ),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Comment : '),
                        Text(doc['comment']),
                      ],
                    ),
                     const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Photos/Videos : '),
                    ),
                    doc['videoFiles'].length == 0
                        ? const SizedBox()
                        : Container(
                            alignment: Alignment.centerLeft,
                            height: 150,
                            width:
                                MediaQuery.of(context).size.width,
                            child: ListView.builder(
                              itemCount: doc['videoFiles'].length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              VideoPlayerPlatform(
                                                  videoUrl:
                                                      doc['videoFiles']
                                                          [index]),
                                        ));
                                  },
                                  child: VideoWidget(
                                      videoUrl: doc['videoFiles']
                                          [index]),
                                );
                              },
                            )),
                    doc['photoFiles'].length == 0
                        ? const SizedBox()
                        : Container(
                            alignment: Alignment.centerLeft,
                            height: 150,
                            width:
                                MediaQuery.of(context).size.width,
                            child: ListView.builder(
                              itemCount: doc['photoFiles'].length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            FullScreenImage(
                                          imageUrl:
                                              doc['photoFiles']
                                                  [index],
                                        ),
                                      )),
                                  child: Container(
                                    padding:
                                        const EdgeInsets.all(5),
                                    height: 120,
                                    width: 90,
                                    child: FittedBox(
                                        fit: BoxFit.fill,
                                        child: Image.network(
                                            doc['photoFiles']
                                                [index])),
                                  ),
                                );
                              },
                            ),
                          ),
                          const Divider(
              thickness: 2,
              color: Colors.black,
              ),
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Price : ',
                  style: TextStyle(fontSize: 22),
                ),
                Text(
                  'RM ' + doc['price'].toStringAsFixed(2),
                  style: const TextStyle(fontSize: 22),
                ),
              ],
              ),
                  ],
                ),
              ),
            );
          } else {
            return const Text('error');
          }
        },
      ),
    );
  }
}

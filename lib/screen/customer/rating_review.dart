import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../service/videos/video_player.dart';
import '../../service/videos/video_widget.dart';
import '../../widgets/full_screen_image.dart';

class RatingReview extends StatelessWidget {
  RatingReview({Key key, this.id}) : super(key: key);
  final String id;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Ratings')),
        body: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('rating')
                .doc(id)
                .collection('rating')
                .get(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final doc = snapshot.data.docs;
                if (doc.isEmpty) {
                  return const Text('No review yet.');
                } else {
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: ListView.builder(
                      itemCount: doc.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(doc[index]['cusID'])
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.active) {
                                        return CircleAvatar(
                                          backgroundColor: Colors.grey,
                                          backgroundImage: NetworkImage(
                                              snapshot.data['imageUrl']),
                                          radius: 8,
                                        );
                                      }
                                      return const CircularProgressIndicator
                                          .adaptive();
                                    }),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  doc[index]['cusName'],
                                  style: const TextStyle(fontSize: 13),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                for (int i = 1;
                                    i <= doc[index]['rating'].round();
                                    i++)
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 13,
                                  ),
                                for (int i = 1;
                                    i <= 5 - doc[index]['rating'].round();
                                    i++)
                                  const Icon(Icons.star_border,
                                      color: Colors.amber, size: 13)
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(doc[index]['comment']),
                            const SizedBox(
                              height: 10,
                            ),
                            doc[index]['videoFiles'].length == 0
                                ? const SizedBox()
                                : Container(
                                    alignment: Alignment.centerLeft,
                                    height: 120,
                                    width: MediaQuery.of(context).size.width,
                                    child: ListView.builder(
                                      itemCount:
                                          doc[index]['videoFiles'].length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, i) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      VideoPlayerPlatform(
                                                          videoUrl: doc[index]
                                                                  ['videoFiles']
                                                              [i]),
                                                ));
                                          },
                                          child: VideoWidget(
                                              videoUrl: doc[index]['videoFiles']
                                                  [i]),
                                        );
                                      },
                                    )),
                            doc[index]['photoFiles'].length == 0
                                ? const SizedBox()
                                : Container(
                                    alignment: Alignment.centerLeft,
                                    height: 120,
                                    width: MediaQuery.of(context).size.width,
                                    child: ListView.builder(
                                      itemCount:
                                          doc[index]['photoFiles'].length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, i) {
                                        return GestureDetector(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    FullScreenImage(
                                                  imageUrl: doc[index]
                                                      ['photoFiles'][i],
                                                ),
                                              )),
                                          child: Container(
                                            padding: const EdgeInsets.all(5),
                                            height: 120,
                                            width: 90,
                                            child: FittedBox(
                                                fit: BoxFit.fill,
                                                child: Image.network(doc[index]
                                                    ['photoFiles'][i])),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                            const Divider(),
                          ],
                        );
                      },
                    ),
                  );
                }
              }
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }),
      ),
    );
  }
}

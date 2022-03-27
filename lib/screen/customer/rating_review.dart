import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
                                const CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  radius: 8,
                                ),
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

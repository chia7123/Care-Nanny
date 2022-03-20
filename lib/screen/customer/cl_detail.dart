import 'package:age_calculator/age_calculator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fyp2/widgets/full_screen_image.dart';

class CLProfileDetail extends StatelessWidget {
  const CLProfileDetail({Key key, this.id}) : super(key: key);
  final String id;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection('users').doc(id).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Something went wrong"),
          );
        }
        if (snapshot.connectionState == ConnectionState.active) {
          final doc = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Profile Detail'),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.78,
                    child: content(context, doc),
                  ),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text('Hire Me'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      },
    );
  }

  Widget content(BuildContext context, dynamic doc) {
    return SingleChildScrollView(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FullScreenImage(imageUrl: doc['imageUrl']),
                )),
            child: CachedNetworkImage(
              imageUrl: doc['imageUrl'],
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
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height * 0.45,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc['name'],
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    doc['rating'] == 0
                        ? Row(
                            children: [
                              for (int i = 1; i <= 5; i++)
                                const Icon(
                                  Icons.star_border,
                                  color: Colors.amber,
                                )
                            ],
                          )
                        : Row(
                            children: [
                              for (int i = 1; i <= doc['rating'].round(); i++)
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                              for (int i = 1;
                                  i <= 5 - doc['rating'].round();
                                  i++)
                                const Icon(
                                  Icons.star_border,
                                  color: Colors.amber,
                                )
                            ],
                          ),
                    const Text(' | '),
                    Text('Order Success: ${doc['orderSuccess']}'),
                    
                  ],
                ),
                
              ],
            ),
          ),
          information(context),
        ],
      ),
    );
  }

  Widget information(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.grey,
          child: Container(
            padding: const EdgeInsets.all(8),
            child: const Text('Personal Information'),
          ),
        ),
      ],
    );
  }
}

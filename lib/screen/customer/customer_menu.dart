import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/menu.dart';
import '../../widgets/full_screen_image.dart';
import '../wrapper.dart';

class CustomerMenu extends StatelessWidget {
  final MenuItem currentItem;
  final ValueChanged<MenuItem> onSelectedItem;

  const CustomerMenu({
    Key key,
    this.currentItem,
    this.onSelectedItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      body: SafeArea(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                final doc = snapshot.data;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          margin: const EdgeInsets.fromLTRB(35, 20, 0, 15),
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            child: CachedNetworkImage(
                              imageUrl: doc['imageUrl'],
                              imageBuilder: (context, imageProvider) =>
                                  CircleAvatar(
                                radius: 60,
                                backgroundImage: imageProvider,
                              ),
                              placeholder: (context, url) => const CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.grey,
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FullScreenImage(
                                          imageUrl: doc['imageUrl'],
                                        ))),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 30),
                          child: Text(
                            doc['name'],
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                    ...CustomerMenuItems.all.map(buildMenuItems).toList(),
                    const Spacer(),
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextButton.icon(
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.pushReplacementNamed(
                              context, Wrapper.routeName);
                        },
                        label: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
            }),
      ),
    );
  }

  Widget buildMenuItems(MenuItem item) => ListTile(
        selectedTileColor: Colors.white24,
        selected: currentItem == item,
        minLeadingWidth: 20,
        leading: Icon(
          item.icon,
          color: Colors.white,
        ),
        title: Text(
          item.title,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        onTap: () => onSelectedItem(item),
      );
}

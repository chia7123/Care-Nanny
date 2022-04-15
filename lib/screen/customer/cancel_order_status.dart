import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/widgets/admin/cancel_order_detail.dart';

import '../../widgets/menu_widget.dart';

class CancelOrderStatusPage extends StatelessWidget {
  CancelOrderStatusPage({Key key}) : super(key: key);
  final String id = FirebaseAuth.instance.currentUser.uid;

  Map<String, Color> color = {
    'pending': Colors.amber,
    'declined': Colors.red[800],
    'approved': Colors.green[600],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const MenuWidget(),
        title: const Text('Refund Orders'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('cancelOrder')
            .where('cusID', isEqualTo: id)
            .orderBy('status', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data.docs.isEmpty) {
              return const Center(child: Text('No Cancel Order'));
            } else {
              final data = snapshot.data.docs;
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 8),
                      elevation: 5,
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CancelOrderDetail(data: data[index]),
                              ));
                        },
                        leading: Text('${index + 1}'),
                        title: Text(data[index]['orderID']),
                        subtitle: const Text('Click to view more details.'),
                        trailing: Container(
                          padding: const EdgeInsets.all(8),
                          color: color[data[index]['status']],
                          child: Text(
                            data[index]['status'][0].toUpperCase() +
                                data[index]['status'].substring(1),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            }
          } else {
            return const Center(child: Text('No data'));
          }
        },
      ),
    );
  }
}

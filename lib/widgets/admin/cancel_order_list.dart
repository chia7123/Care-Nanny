import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2/widgets/admin/cancel_order_detail.dart';

class CancelOrderList extends StatefulWidget {
  const CancelOrderList({Key key}) : super(key: key);

  @override
  State<CancelOrderList> createState() => _CancelOrderListState();
}

class _CancelOrderListState extends State<CancelOrderList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('cancelOrder')
            .orderBy('status', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final data = snapshot.data.docs;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                bool isPending;
                data[index]['status'] == 'pending'
                    ? isPending = true
                    : isPending = false;
                return ListTile(
                    tileColor: !isPending ? Colors.grey[200] : null,
                    minLeadingWidth: 5,
                    horizontalTitleGap: 5,
                    isThreeLine: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CancelOrderDetail(
                            data: data[index],
                          ),
                        ),
                      );
                    },
                    leading: Text('${index + 1}.'),
                    title: Text(
                      data[index]['orderID'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reason: ${data[index]['cancelReason']}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Text('Click to view more details.'),
                      ],
                    ),
                    trailing: isPending
                        ? SizedBox(
                            width: 80,
                            child: Row(
                              children: [
                                Container(
                                  width: 35,
                                  decoration: BoxDecoration(
                                      color: Colors.green[600],
                                      shape: BoxShape.circle),
                                  child: IconButton(
                                    color: Colors.white,
                                    icon: const Icon(Icons.check),
                                    iconSize: 16,
                                    onPressed: () =>
                                        approveRequest(data[index]),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  width: 35,
                                  decoration: BoxDecoration(
                                      color: Colors.red[800],
                                      shape: BoxShape.circle),
                                  child: IconButton(
                                    color: Colors.white,
                                    icon: const Icon(Icons.close),
                                    iconSize: 16,
                                    onPressed: () => rejectRequest(data[index]),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const ElevatedButton(
                            child: Text('Reviewed'),
                            onPressed: null,
                          ));
              },
            );
          }
          return const Center(
            child: Text('No data'),
          );
        });
  }

  void approveRequest(dynamic data) {
    FirebaseFirestore.instance
        .collection('cancelOrder')
        .doc(data['orderID'])
        .update({'status': 'approved'}).whenComplete(
            () => Fluttertoast.showToast(msg: 'Request Approved'));
  }

  void rejectRequest(dynamic data) {
    FirebaseFirestore.instance
        .collection('cancelOrder')
        .doc(data['orderID'])
        .update({'status': 'declined'}).whenComplete(
            () => Fluttertoast.showToast(msg: 'Request Declined'));
  }
}

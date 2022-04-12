import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/widgets/admin/cancel_order_detail.dart';
import 'package:intl/intl.dart';

import 'order_detail.dart';

class OrderList extends StatefulWidget {
  const OrderList({Key key, this.stream}) : super(key: key);
  final Stream<QuerySnapshot<Map<String, dynamic>>> stream;

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.stream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final data = snapshot.data.docs;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  tileColor: Colors.grey[300],
                  minLeadingWidth: 5,
                  horizontalTitleGap: 5,
                  isThreeLine: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderDetail(
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
                        '${DateFormat('yyyy/MM/dd').format(data[index]['startDate'].toDate())} - ${DateFormat('yyyy/MM/dd').format(data[index]['endDate'].toDate())}',
                      ),
                      const Text('Click to view more details.'),
                    ],
                  ),
                  trailing: Text(
                    'RM ${data[index]['price'].toStringAsFixed(2)}',
                  ),
                );
              },
            );
          }
          return const Center(
            child: Text('No data'),
          );
        });
  }
}

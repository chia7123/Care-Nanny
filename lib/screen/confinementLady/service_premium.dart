import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PremiumService extends StatelessWidget {
  PremiumService({Key key}) : super(key: key);
  final uid = FirebaseAuth.instance.currentUser.uid;

  TextEditingController title = TextEditingController();
  TextEditingController price = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _listOfService(context),
          _totalPrice(context),
          _inputArea(context),
        ],
      ),
    );
  }

  Widget _listOfService(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(border: Border.all()),
      child: Container(
        decoration: BoxDecoration(border: Border.all()),
        height: MediaQuery.of(context).size.height * 0.4,
        width: double.infinity,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('service')
              .doc(uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              final data = snapshot.data;
              if (data['premium'].length == 0) {
                return const Center(
                  child: Text('Start add the service.'),
                );
              }
              return ListView.builder(
                  itemCount: data['premium'].length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Dismissible(
                          direction: DismissDirection.endToStart,
                          background: Container(
                            padding: const EdgeInsets.only(right: 15),
                            color: Colors.red,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          onDismissed: (direction) {
                            if (direction == DismissDirection.endToStart) {
                              Map<String, dynamic> serviceInfo = {
                                'title': data['premium'][index]['title'],
                                'price': data['premium'][index]['price'],
                              };
                              _deleteService(serviceInfo);
                            }
                          },
                          key: Key(data['premium'][index]['title']),
                          child: ListTile(
                            title: Text(
                                '${index + 1}. ${data['premium'][index]['title']}'),
                            subtitle: Text(
                                'RM ${double.parse(data['premium'][index]['price']).toStringAsFixed(2)}'),
                          ),
                        ),
                        Divider(
                          color: Colors.grey[800],
                        ),
                      ],
                    );
                  });
            }
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          },
        ),
      ),
    );
  }

  Widget _totalPrice(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('service')
            .doc(uid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final datas = snapshot.data['premium'];
            double totalPrice = 0;
            for (var data in datas) {
              totalPrice += double.parse(data['price']);
            }

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Package Price (RM) : ',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    '${totalPrice.toStringAsFixed(2)} (daily)',
                    style: const TextStyle(fontSize: 24),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        });
  }

  Widget _inputArea(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: const Text('Service Name : '),
              ),
              Expanded(
                child: TextField(
                  controller: title,
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: const Text('Price (RM) : ')),
              Expanded(
                child: TextField(
                  controller: price,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () => _addService(),
              child: const Text('Add'),
            ),
          ),
        ],
      ),
    );
  }

  _addService() async {
    final String titles = title.text;
    final String prices = price.text;

    if (titles.isEmpty || prices.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please fill in the service name/price before add the service.');
      return;
    }

    if (double.parse(price.text) < 0) {
      Fluttertoast.showToast(msg: 'Please fill in a valid price.');
      return;
    }
    Map<String, dynamic> serviceInfo = {
      'title': title.text,
      'price': price.text,
    };

    FirebaseFirestore.instance.collection('service').doc(uid).update({
      'premium': FieldValue.arrayUnion([serviceInfo]),
    }).whenComplete(() {
      title.value = TextEditingValue.empty;
      price.value = TextEditingValue.empty;
      Fluttertoast.showToast(msg: 'Service added.');
    });
  }

  _deleteService(Map<String, dynamic> serviceInfo) async {
    FirebaseFirestore.instance.collection('service').doc(uid).update({
      'premium': FieldValue.arrayRemove([serviceInfo])
    }).whenComplete(
        () => Fluttertoast.showToast(msg: '${serviceInfo['title']} deleted.'));
  }
}

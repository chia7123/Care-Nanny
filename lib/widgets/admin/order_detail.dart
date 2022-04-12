import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderDetail extends StatelessWidget {
  const OrderDetail({Key key, this.data}) : super(key: key);
  final dynamic data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Information'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Order ID: ',
                      ),
                      Text(
                        data['orderID'],
                      )
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Confinement Date: ',
                      ),
                      Text(
                        '${DateFormat('yyyy/MM/dd').format(data['startDate'].toDate())} - ${DateFormat('yyyy/MM/dd').format(data['endDate'].toDate())}',
                      )
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Package Name: ',
                      ),
                      Text(
                        data['typeOfService'],
                      )
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Package Price: ',
                      ),
                      Text(
                        'RM ${data['price'].toStringAsFixed(2)}',
                      )
                    ]),
              ),
              const Divider(
                thickness: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(children: [
                  const Text(
                    'Service Provider ID:',
                  ),
                  const Spacer(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Text(
                      data['clID'],
                    ),
                  )
                ]),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(children: [
                  const Text(
                    'Buyer ID:',
                  ),
                  const Spacer(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Text(
                      data['cusID'],
                    ),
                  )
                ]),
              ),
              const Divider(
                thickness: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Services Included: ',
                      ),
                      Container(
                        height: 250,
                        width: MediaQuery.of(context).size.width * 0.5,
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                        child: ListView.builder(
                          itemCount: data['serviceSelected'].length,
                          itemBuilder: (context, index) =>
                              Text(data['serviceSelected'][index]),
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

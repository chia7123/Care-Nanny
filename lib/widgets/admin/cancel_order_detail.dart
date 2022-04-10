import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CancelOrderDetail extends StatelessWidget {
  CancelOrderDetail({Key key, this.data}) : super(key: key);
  final dynamic data;
  Map<String, Color> color = {
    'pending': Colors.amber,
    'declined': Colors.red[800],
    'approved': Colors.green[600],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Detail'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Status',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        color: color[data['status']],
                        child: Text(
                          data['status'][0].toUpperCase() +
                              data['status'].substring(1),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
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
                    'Confinement Lady ID:',
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
                    'Mother ID:',
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
                child: Row(children: [
                  const Text(
                    'Cancel Reason',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Text(
                      data['cancelReason'],
                    ),
                  )
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

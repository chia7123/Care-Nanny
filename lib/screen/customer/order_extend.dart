import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2/service/date_range_picker_extend.dart';
import 'package:intl/intl.dart';

import '../../service/payment.dart';
import '../info_page.dart';

class ExtendOrder extends StatefulWidget {
  ExtendOrder({Key key, this.doc}) : super(key: key);
  final dynamic doc;

  @override
  State<ExtendOrder> createState() => _ExtendOrderState();
}

class _ExtendOrderState extends State<ExtendOrder> {
  DateTime _endDate;
  DateTime _startDate;
  int _days;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Extend Order'),
          ),
          body: Column(
            children: [
              Expanded(
                child: SizedBox(
                  child: content(context),
                ),
              ),
              Container(
                height: 8,
                width: MediaQuery.of(context).size.width,
                color: Colors.grey[300],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => submit(context, widget.doc),
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  child: const Text('Extend'),
                ),
              )
            ],
          )),
    );
  }

  Widget content(BuildContext context) {
    _startDate = widget.doc['startDate'].toDate();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 16, 0, 16),
            child: Text(
              'Extend Order Detail',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Container(
            height: 8,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[300],
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 8, 0, 0),
            child: Text(
              'Confinement Package',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.doc['typeOfService'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 15,
                  ),
                ),
                Text(
                  'RM ${widget.doc['price'].toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 8,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[300],
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 8, 0, 0),
            child: Text(
              'Services Included',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          Container(
            height: 180,
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: ListView.builder(
              itemCount: widget.doc['serviceSelected'].length,
              itemBuilder: (context, index) =>
                  Text(widget.doc['serviceSelected'][index]),
            ),
          ),
          Container(
            height: 8,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[300],
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 8, 0, 0),
            child: Text(
              'Extend Date',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Current Service Date :\n${DateFormat('yyyy-MM-dd').format(_startDate)} - ${DateFormat('yyyy-MM-dd').format(widget.doc['endDate'].toDate())}',
                      style: const TextStyle(),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _endDate != null
                        ? Text(
                            'Updated Service Date :\n${DateFormat('yyyy-MM-dd').format(_startDate)} - ${DateFormat('yyyy-MM-dd').format(_endDate)}')
                        : const SizedBox(),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => DateRangePickerExtend(
                          clID: widget.doc['clID'],
                          orderID: widget.doc['orderID'],
                          selectedDate: _getSelectedDate,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.calendar_month),
                  label: const Text('Extend'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 8,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[300],
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 8, 0, 0),
            child: Text(
              'Price Detail',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Daily Price: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'RM ${widget.doc['dailyPrice'].toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Number of Extend Day: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 15,
                      ),
                    ),
                    _days == null
                        ? const SizedBox()
                        : Text(
                            _days.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 15,
                            ),
                          ),
                  ],
                ),
                const Divider(
                  thickness: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Price: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 15,
                      ),
                    ),
                    _days == null
                        ? const SizedBox()
                        : Text(
                            'RM ${(widget.doc['dailyPrice'] * _days).toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 15,
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _getSelectedDate(DateTime endDate, int days) {
    setState(() {
      _endDate = endDate;
      _days = days;
    });
  }

  submit(BuildContext context, dynamic doc) async {
    if (_endDate == null) {
      Fluttertoast.showToast(msg: 'Please extend the date of the order first.');
      return;
    }

    double extendPrice = doc['dailyPrice'] * _days;

    BraintreeDropInResult result =
        await Payment().paymentRequest(price: extendPrice);

    if (result != null) {
      await FirebaseFirestore.instance
          .collection('onProgressOrder')
          .doc(doc['orderID'])
          .update({
        'endDate': _endDate,
        'totalDays': doc['totalDays'] + _days,
        'price': doc['price'] + extendPrice,
      }).whenComplete(() {
        String msg = 'Your order had been extended.';

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => InfoPage(
                msg: msg,
                color: Colors.green,
                imgUrl: 'assets/images/tick.png',
              ),
            ));
      });
    } else {
      Fluttertoast.showToast(msg: 'Plese make the payment to extend your order.');
    }
  }
}

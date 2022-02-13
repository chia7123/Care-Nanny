import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2/service/database.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateRangePickerExtend extends StatefulWidget {
  DateRangePickerExtend({Key key, this.orderID}) : super(key: key);
  final String orderID;

  @override
  State<DateRangePickerExtend> createState() => _DateRangePickerExtendState();
}

class _DateRangePickerExtendState extends State<DateRangePickerExtend> {
  // DateTime _startDate;
  DateTime _endDate;
  DateRangePickerController _dateController = DateRangePickerController();
  DateTime occupiedStartDate;
  DateTime occupiedEndDate;
  List<DateTime> _blackOutDates = [];

  void _updateOrderDate() {
    Navigator.of(context).pop();
    Fluttertoast.showToast(msg: 'Date Updated');
    Database().updateProgressOrder(widget.orderID, {
      'endDate': _endDate,
    });
  }

  @override
  void initState() {
    getBookedDate();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getBookedDate() async {
    await Database()
        .getProgressOrder(widget.orderID)
        .then((DocumentSnapshot snapshot) {
      Map<String, dynamic> doc = snapshot.data();
      occupiedStartDate = doc['startDate'].toDate();
      occupiedEndDate = doc['endDate'].toDate();
    });

    for (var date = occupiedStartDate;
        date.isBefore(occupiedEndDate) || date == occupiedEndDate;
        date = date.add(const Duration(days: 1))) {
      _blackOutDates.add(date);
    }
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    _endDate = args.value.endDate;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SfDateRangePicker(
          enableMultiView: true,
          navigationDirection: DateRangePickerNavigationDirection.vertical,
          initialSelectedRange: PickerDateRange(occupiedStartDate, occupiedEndDate),
          extendableRangeSelectionDirection:
              ExtendableRangeSelectionDirection.forward,
          headerHeight: 60,
          headerStyle: DateRangePickerHeaderStyle(
            textAlign: TextAlign.center,
            backgroundColor: Theme.of(context).primaryColor,
            textStyle: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          monthViewSettings: DateRangePickerMonthViewSettings(

            blackoutDates: _blackOutDates,
          ),
          monthCellStyle: const DateRangePickerMonthCellStyle(
            blackoutDateTextStyle: TextStyle(
                color: Colors.red, decoration: TextDecoration.lineThrough),
          ),
          onSelectionChanged: _onSelectionChanged,
          selectionShape: DateRangePickerSelectionShape.circle,
          showActionButtons: true,
          controller: _dateController,
          selectionMode: DateRangePickerSelectionMode.range,
          onSubmit: (value) {
            _updateOrderDate();
          },
          onCancel: () {
            _dateController = null;
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}

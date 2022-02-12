import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/service/database.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateRangePicker extends StatefulWidget {
  DateRangePicker({Key key, this.orderID, this.clId}) : super(key: key);
  final String orderID;
  final String clId;

  @override
  State<DateRangePicker> createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {
  DateTime _startDate;
  DateTime _endDate;
  DateRangePickerController _dateController = DateRangePickerController();
  List<DateTime> occupiedStartDate = [];
  List<DateTime> occupiedEndDate = [];
  List<DateTime> _blackOutDates = [];

  Future _updateOrderDate() {
    Navigator.of(context).pop();
    return Database().updateOrderData(widget.orderID, {
      'startDate': _startDate,
      'endDate': _endDate,
    });
  }

  @override
  void initState() {
    getBookedDate();
    super.initState();
  }

  void getBookedDate() async {
    await FirebaseFirestore.instance
        .collection('onProgressOrder')
        .where('clID', isEqualTo: widget.clId)
        .get()
        .then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        occupiedStartDate.add(doc['startDate'].toDate());
        occupiedEndDate.add(doc['endDate'].toDate());
      }
    });
    for (var i = 0; i < occupiedStartDate.length; i++) {
      for (var date = occupiedStartDate[i];
          date.isBefore(occupiedEndDate[i]) || date == occupiedEndDate[i];
          date = date.add(const Duration(days: 1))) {

        _blackOutDates.add(date);
      }
      print(_blackOutDates);
    }
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    _startDate = args.value.startDate;
    _endDate = args.value.endDate;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SfDateRangePicker(
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
          initialSelectedRange: PickerDateRange(
              DateTime.now(), DateTime.now().add(const Duration(days: 3))),
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

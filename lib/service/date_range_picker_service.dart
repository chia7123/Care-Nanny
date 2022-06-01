import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateRangePickerService extends StatefulWidget {
  DateRangePickerService({Key key, this.clId, this.selectDateTime})
      : super(key: key);

  final String clId;
  final Function(DateTime, DateTime, int) selectDateTime;

  @override
  State<DateRangePickerService> createState() => _DateRangePickerServiceState();
}

class _DateRangePickerServiceState extends State<DateRangePickerService> {
  DateTime _startDate;
  DateTime _endDate;
  int days;
  DateRangePickerController _dateController = DateRangePickerController();
  List<DateTime> occupiedStartDate = [];
  List<DateTime> occupiedEndDate = [];
  List<DateTime> _blackOutDates = [];

  void _updateOrderDate() {
    days = daysBetween(_startDate, _endDate);
    print('check ' + days.toString());
    widget.selectDateTime(_startDate, _endDate, days);
    Navigator.of(context).pop();
    Fluttertoast.showToast(msg: 'Date Selected');
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
    }
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    _startDate = args.value.startDate;
    _endDate = args.value.endDate;
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return ((to.difference(from).inHours / 24).round() + 1);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SfDateRangePicker(
          minDate: DateTime.now(),
          enableMultiView: true,
          navigationDirection: DateRangePickerNavigationDirection.vertical,
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
            if (_startDate == null || _endDate == null) {
              Fluttertoast.showToast(msg: 'Please select at least two dates');
            }
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

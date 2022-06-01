import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateRangePickerExtend extends StatefulWidget {
  DateRangePickerExtend({Key key, this.clID, this.orderID, this.selectedDate, this.minDate})
      : super(key: key);
  final String orderID;
  final String clID;
  final DateTime minDate;
  final Function(DateTime, int) selectedDate;

  @override
  State<DateRangePickerExtend> createState() => _DateRangePickerExtendState();
}

class _DateRangePickerExtendState extends State<DateRangePickerExtend> {
  DateTime _startDate;
  DateTime _endDate;
  DateRangePickerController _dateController = DateRangePickerController();
  int days;
  List<DateTime> occupiedStartDate = [];
  List<DateTime> occupiedEndDate = [];
  List<DateTime> _blackOutDates = [];

  void _updateOrderDate() {
    days = daysBetween(_startDate, _endDate);
    Navigator.of(context).pop();
    print('check $days');
    widget.selectedDate(_endDate, days);
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return ((to.difference(from).inHours / 24).round() + 1);
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
        .where('clID', isEqualTo: widget.clID)
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SfDateRangePicker(
          minDate: widget.minDate,
          initialDisplayDate: null,
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

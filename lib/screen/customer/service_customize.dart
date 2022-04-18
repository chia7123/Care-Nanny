import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../models/service.dart';

class CustomizeService extends StatefulWidget {
  const CustomizeService({
    Key key,
    this.selectPackage,
    this.serviceType, this.price,
  }) : super(key: key);
  final Function(Map<String, dynamic>) selectPackage;
  final List<Service> serviceType;
  final double price;

  @override
  State<CustomizeService> createState() => _CustomizeServiceState();
}

class _CustomizeServiceState extends State<CustomizeService> {
  List<Service> _typeService;

  List<String> serviceSelected = [];
  double totalPrice = 0;

  @override
  void initState() {
    _typeService = widget.serviceType;
    for (int i = 0; i < _typeService.length; i++) {
      _typeService[i].value = true;
      serviceSelected.add(_typeService[i].name);
    }
    totalPrice = widget.price;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Please customize your service')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: Scrollbar(
                thickness: 5,
                radius: const Radius.circular(10),
                child: ListView.builder(
                    itemCount: _typeService.length,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        checkColor: Colors.white,
                        activeColor: Theme.of(context).primaryColor,
                        title: Text(_typeService[index].name),
                        subtitle: Text(
                          'RM ${_typeService[index].price.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        value: _typeService[index].value,
                        onChanged: (values) {
                          setState(() {
                            _typeService[index].value = values;
                            _calculatePrice(index);
                            getCheckboxItems(index);
                          });
                        },
                      );
                    }),
              ),
            ),
          ),
          SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
               const Text(
                 'Total Price :',
                 style: TextStyle(
                   fontSize: 20,
                 ),
               ),
                Text(
                  'RM ${totalPrice.toStringAsFixed(2)}',
                  style:
                      const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.06,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: addCheckBoxItems,
              child: const Text(
                'Add to Cart',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  onPrimary: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  void getCheckboxItems(int index) {
    if (_typeService[index].value == true) {
      serviceSelected.add(_typeService[index].name);
    }
    if (_typeService[index].value == false) {
      serviceSelected.remove(_typeService[index].name);
    }
  }

  void _calculatePrice(int index) {
    if (_typeService[index].value == true) {
      totalPrice = totalPrice + _typeService[index].price;
    }
    if (_typeService[index].value == false) {
      totalPrice = totalPrice - _typeService[index].price;
    }
  }

  Future<void> addCheckBoxItems() {
    if (serviceSelected.isEmpty) {
      Fluttertoast.showToast(msg: 'Please select at least one of the service');
      return null;
    }
    Fluttertoast.showToast(msg: 'Service added');
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    return widget.selectPackage({
      'typeOfService': 'Customize Service Package',
      'serviceSelected': serviceSelected,
      'price': totalPrice,
    });
  }
}

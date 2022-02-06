
import 'package:flutter/material.dart';

class ServicePackage {
  final String packageName;
  final double price;
  final List<String> details;
  final Color colors;

  ServicePackage({
    this.packageName,
    this.details,
    this.price,
    this.colors,
  });
}

class Service {
  final String name;
  final double price;
  bool value;

  Service({this.name, this.price, this.value = false});
}
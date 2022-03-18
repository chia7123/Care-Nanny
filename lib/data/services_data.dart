import 'package:flutter/material.dart';
import 'package:fyp2/models/service.dart';


List<Service> serviceType = [
  Service(
    name: '1x Prenanatal Massage',
    price: 200.00,
  ),
  Service(
    name: '1x Postnantal Massage',
    price: 300.00,
  ),
  Service(
    name: '1x Live-in Confinement',
    price: 300.00,
  ),
  Service(
    name: '1x Day-Time Confinement',
    price: 150.00,
  ),
  Service(
    name: '1x Confinement Food Catering',
    price: 500.00,
  ),
  Service(
    name: '1x Baby Care',
    price: 250.00,
  ),
];

List<ServicePackage> defaultPackage = [
  ServicePackage(
    packageName: 'Basic Package',
    price: 2099.99,
    details: [
      '1x Prenantal Massage',
      '1x Postnantal Massage',
      '1x Day-Time Confinement',
      '5x Confinement Food Catering',
      '1x Baby Care',
    ],
    colors: Colors.lightBlue,
  ),
  ServicePackage(
    packageName: 'Premium Package',
    price: 3099.99,
    details: [
      '1x Prenantal Massage',
      '1x Postnantal Massage',
      '1x Day-Time Confinement',
      '5x Confinement Food Catering',
      '1x Baby Care',
    ],
    colors: Colors.amber
  ),
  ServicePackage(
    packageName: 'Deluxe Package',
    price: 4099.99,
    details: [
      '1x Prenantal Massage',
      '1x Postnantal Massage',
      '1x Day-Time Confinement',
      '5x Confinement Food Catering',
      '1x Baby Care',
      '1x Prenantal Massage',
      '1x Postnantal Massage',
      '1x Day-Time Confinement',
      '5x Confinement Food Catering',
      '1x Baby Care',
    ],
    colors: Colors.lightGreen
  ),
];

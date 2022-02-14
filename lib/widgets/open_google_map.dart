import 'package:flutter/material.dart';
import 'package:fyp2/service/google_api.dart';

class openMap extends StatelessWidget {
  const openMap({Key key, this.address}) : super(key: key);
  final String address;
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => GoogleAPI().navigateTo(address),
      icon: const Icon(Icons.map),
      label: const Text('Open Maps'),
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(10), onPrimary: Colors.white,),
    );
  }
}

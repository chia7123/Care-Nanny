import 'dart:math';

import 'package:geolocator/geolocator.dart';

class LocationService {

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
  }

  double computeDistance(double startLat,double startLng,double endLat,double endLng){
    double distanceInMeters = Geolocator.distanceBetween(startLat, startLng, endLat, endLng);

    return distanceInMeters;
  }

   double degreesToRadians(double degrees){
    return degrees * pi / 180;
  }

  //Harvesine algorithm
  double distance(double startLat,double startLng,double endLat,double endLng){
    double earthRadiusKm = 6371;

    var dLat = degreesToRadians(endLat  - startLat);
    var dLon = degreesToRadians(endLng - startLng);

    var a = sin(dLat / 2) * sin(dLat / 2) +
            sin(dLon / 2) * sin(dLon / 2) * 
            cos(degreesToRadians(startLat)) * cos(degreesToRadians(endLat));

    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusKm * c;
  }


}

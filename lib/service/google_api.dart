import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';

class GoogleAPI {
  String apiKey = 'AIzaSyC8d6OcB6tiY3-W--lsRgQdBCfMUWyY6Ns';

  Future<Map<String, dynamic>> getAddress(Position position) async {
    Response response;
    Map<String, dynamic> address;

    response = await Dio().get(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey');
    address = response.data['results'][0];
    return address;
  }
}

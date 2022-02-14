import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Future<dynamic> getGeocode(String address) async {
    Response response;
    dynamic geocode;

    response = await Dio().get(
        'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$apiKey');

    geocode = response.data['results'][0]['geometry']['location'];

    return geocode;
  }

  void navigateTo(String address) async {
    var position = await GoogleAPI().getGeocode(address);

    var uri = Uri.parse(
        "google.navigation:q=${position['lat']},${position['lng']}&mode=d");
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch ${uri.toString()}';
    }
  }
}

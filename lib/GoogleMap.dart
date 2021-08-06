
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
Future<String> fetchLocation() async {
  //final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position position = await geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best);///Here you have choose level of distance

  var placemarks = await geolocator.placemarkFromCoordinates(position.latitude, position.longitude);
  String loc="";



  loc='${placemarks.first.thoroughfare}' +' '+'${placemarks.first.name}' +' '+'${placemarks.first.locality}' +' '+'${placemarks.first.country}';
  return loc;


}

void launchMap( String str_location) async {
  String url;
  url ="http://maps.google.co.in/maps?q=" + str_location;

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

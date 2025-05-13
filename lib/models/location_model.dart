import 'package:student_75/app_settings.dart';

class Location {
  String name;
  double latitude;
  double longitude;
  double radius;

  Location(
      {required this.name, required this.latitude, required this.longitude})
      : radius = AppSettings.locationRadius;
}

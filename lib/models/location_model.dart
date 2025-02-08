//todo move this to some app_settings file
const DEFAULT_LOCATION_RADIUS = 100.0;

class Location {
  String name;
  double latitude;
  double longitude;
  double radius;

  Location(
      {required this.name,
      required this.latitude,
      required this.longitude,
      this.radius = DEFAULT_LOCATION_RADIUS});
}

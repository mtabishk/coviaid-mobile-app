import 'package:location/location.dart';

class LocationDataModel {
  LocationDataModel({this.latitude, this.longitude});
  final latitude;
  final longitude;
}

class LocationService {
  Future<LocationDataModel> currentLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return LocationDataModel(
          latitude: null,
          longitude: null,
        );
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return LocationDataModel(
          latitude: null,
          longitude: null,
        );
      }
    }

    _locationData = await location.getLocation();

    print(_locationData);

    return LocationDataModel(
      latitude: _locationData.latitude.toString(),
      longitude: _locationData.longitude.toString(),
    );
  }
}

import 'package:latlong2/latlong.dart';

abstract class HomeRemoteDatasource {
  Future<LatLng> fetchCurrentLocation();
}

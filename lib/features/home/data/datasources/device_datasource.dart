import 'package:latlong2/latlong.dart';

import 'home_datasource.dart';

class DeviceDatasource implements HomeRemoteDatasource{
  @override
  Future<LatLng> fetchCurrentLocation() {
    // TODO: implement fetchCurrentLocation
    throw UnimplementedError();
  }
}
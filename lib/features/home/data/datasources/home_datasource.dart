import '../models/user_location.dart';

abstract class HomeRemoteDatasource {
  Future<UserLocation> fetchCurrentLocation();
}

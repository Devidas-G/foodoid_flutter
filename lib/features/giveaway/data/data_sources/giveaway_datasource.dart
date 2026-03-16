import '../models/user_location.dart';

abstract class GiveawayRemoteDatasource {
  Future<UserLocation> fetchCurrentLocation();
}

import '../models/user_location.dart';
import '../models/nearby_giveaway_model.dart';

abstract class HomeRemoteDatasource {
  Future<UserLocation> fetchCurrentLocation();

  /// Fetch nearby giveaways from server for given latitude and longitude.
  Future<List<NearbyGiveawayModel>> fetchNearbyGiveaways(
    double lat,
    double lng, {
    List<String>? status,
    List<String>? foodType,
  });
}

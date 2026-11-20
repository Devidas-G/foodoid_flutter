import '../models/user_location.dart';
import '../models/giveaway_model.dart';

abstract class GiveawayRemoteDatasource {
  Future<UserLocation> fetchCurrentLocation();

  /// Sends giveaway data to remote API.
  /// Should throw on network/validation errors using CustomException.
  Future<void> submitGiveaway(GiveawayModel giveaway);
}

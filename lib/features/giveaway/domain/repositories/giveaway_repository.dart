import '../../../../core/utils/typedef.dart';
import '../entities/user_location_entity.dart';
import '../entities/giveaway_entity.dart';

abstract class GiveawayRepository {
  ResultFuture<UserLocationEntity> fetchCurrentLocation();

  /// Submit giveaway data to repository.
  VoidResult submitGiveaway(GiveawayEntity params);
}

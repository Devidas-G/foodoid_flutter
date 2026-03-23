import '../../../../core/utils/typedef.dart';
import '../entities/user_location_entity.dart';
import '../entities/nearby_giveaway_entity.dart';

abstract class HomeRepository {
  ResultFuture<UserLocationEntity> fetchCurrentLocation();

  ResultFuture<List<NearbyGiveawayEntity>> getNearbyGiveaways(double lat, double lng);
}

import '../../../../core/domain/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../entities/nearby_giveaway_entity.dart';
import '../repositories/home_repository.dart';

class NearbyParams {
  final double lat;
  final double lng;

  NearbyParams({required this.lat, required this.lng});
}

class GetNearbyGiveaways implements UseCase<List<NearbyGiveawayEntity>, NearbyParams> {
  final HomeRepository repository;

  GetNearbyGiveaways(this.repository);

  @override
  ResultFuture<List<NearbyGiveawayEntity>> call(NearbyParams params) async {
    return await repository.getNearbyGiveaways(params.lat, params.lng);
  }
}

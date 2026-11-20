import '../../../../core/domain/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../entities/user_location_entity.dart';
import '../repositories/home_repository.dart';

class GetCurrentLocation implements UseCase<UserLocationEntity, NoParams> {
  final HomeRepository repository;

  GetCurrentLocation(this.repository);
  @override
  ResultFuture<UserLocationEntity> call(NoParams params) async {
    return await repository.fetchCurrentLocation();
  }
}

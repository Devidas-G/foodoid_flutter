import '../../../../core/utils/typedef.dart';
import '../entities/user_location_entity.dart';

abstract class HomeRepository {
  ResultFuture<UserLocationEntity> fetchCurrentLocation();
}

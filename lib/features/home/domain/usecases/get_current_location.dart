import 'package:latlong2/latlong.dart';

import '../../../../core/domain/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../repositories/home_repository.dart';

class GetCurrentLocation implements UseCase<LatLng, NoParams> {
  final HomeRepository repository;

  GetCurrentLocation(this.repository);
  @override
  ResultFuture<LatLng> call(NoParams params) async {
    return await repository.fetchCurrentLocation();
  }
}

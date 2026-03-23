import 'package:dartz/dartz.dart';

import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/typedef.dart';
import '../../domain/entities/nearby_giveaway_entity.dart';
import '../../domain/entities/user_location_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_datasource.dart';

class HomeRepositoryImplementation extends HomeRepository {
  final HomeRemoteDatasource remoteDatasource;

  HomeRepositoryImplementation(this.remoteDatasource);

  @override
  ResultFuture<UserLocationEntity> fetchCurrentLocation() async {
    try {
      final result = await remoteDatasource.fetchCurrentLocation();
      return Right(result);
    } on CustomException catch (e) {
      if (e.message.contains('Location services are disabled')) {
        return Left(LocationFailure(e.message));
      } else if (e.message.contains('Location permission')) {
        return Left(LocationFailure(e.message));
      } else if (e.message.contains('Network')) {
        return Left(NetworkFailure(e.message));
      } else {
        return Left(LocationFailure(e.message));
      }
    } catch (e) {
      return Left(LocationFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  ResultFuture<List<NearbyGiveawayEntity>> getNearbyGiveaways(
    double lat,
    double lng, {
    List<String>? status,
    List<String>? foodType,
  }) async {
    try {
      final models = await remoteDatasource.fetchNearbyGiveaways(lat, lng, status: status, foodType: foodType);
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } on CustomException catch (e) {
      if (e.message.contains('Network')) {
        return Left(NetworkFailure(e.message));
      } else {
        return Left(LocationFailure(e.message));
      }
    } catch (e) {
      return Left(LocationFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}

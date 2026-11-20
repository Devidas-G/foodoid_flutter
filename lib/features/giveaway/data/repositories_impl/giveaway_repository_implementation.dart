import 'package:dartz/dartz.dart';

import 'package:foodoid/core/errors/exception.dart';
import 'package:foodoid/core/errors/failure.dart';
import 'package:foodoid/core/utils/typedef.dart';
import '../../domain/entities/user_location_entity.dart';
import '../../domain/repositories/giveaway_repository.dart';
import '../data_sources/giveaway_datasource.dart';
import '../../domain/entities/giveaway_entity.dart';
import '../models/giveaway_model.dart';

class GiveawayRepositoryImplementation extends GiveawayRepository {
  final GiveawayRemoteDatasource remoteDatasource;

  GiveawayRepositoryImplementation(this.remoteDatasource);

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
  Future<Either<Failure, Unit>> submitGiveaway(GiveawayEntity params) async {
    try {
      final model = GiveawayModel.fromEntity(params);
      await remoteDatasource.submitGiveaway(model);
      return const Right(unit);
    } on CustomException catch (e) {
      if (e.message.contains('Network')) {
        return Left(NetworkFailure(e.message));
      }
      return Left(LocationFailure(e.message));
    } catch (e) {
      return Left(LocationFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}

import 'package:dartz/dartz.dart';

import 'package:foodoid/core/errors/exception.dart';
import 'package:foodoid/core/errors/failure.dart';
import 'package:foodoid/core/utils/typedef.dart';
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
}

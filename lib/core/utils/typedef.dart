import 'package:dartz/dartz.dart';
import '../errors/failure.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;
typedef ResultStream<T> = Stream<Either<Failure, T>>;
typedef VoidResult = Future<Either<Failure, Unit>>;

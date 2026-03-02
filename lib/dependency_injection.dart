import 'package:get_it/get_it.dart';

import 'features/home/data/datasources/device_datasource.dart';
import 'features/home/data/datasources/home_datasource.dart';
import 'features/home/data/repositories/home_repository_implementation.dart';
import 'features/home/domain/repositories/home_repository.dart';
import 'features/home/domain/usecases/get_current_location.dart';
import 'features/home/presentation/bloc/home_bloc.dart';

final GetIt sl = GetIt.instance;

/// Initializes the service locator and register dependencies.
Future<void> init() async {
  // BLoCs
  sl.registerFactory<HomeBloc>(() => HomeBloc(getCurrentLocation: sl()));

  // UseCases
  sl.registerLazySingleton<GetCurrentLocation>(()=>GetCurrentLocation(sl()));

  // Repositories
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImplementation(sl()));

  // Data Sources
  sl.registerLazySingleton<HomeRemoteDatasource>(() => DeviceDatasource());
}

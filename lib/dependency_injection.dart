import 'package:get_it/get_it.dart';

import 'features/giveaway/data/data_sources/device_datasource.dart' as GA;
import 'features/giveaway/data/data_sources/giveaway_datasource.dart';
import 'features/giveaway/data/repositories_impl/giveaway_repository_implementation.dart';
import 'features/giveaway/domain/repositories/giveaway_repository.dart';
import 'features/giveaway/domain/use_cases/get_current_location.dart' as GA;
import 'features/giveaway/domain/use_cases/submit_giveaway.dart';
import 'features/giveaway/presentation/bloc/giveaway_bloc.dart';
import 'features/home/data/datasources/device_datasource.dart';
import 'features/home/data/datasources/home_datasource.dart';
import 'features/home/data/repositories/home_repository_implementation.dart';
import 'features/home/domain/repositories/home_repository.dart';
import 'features/home/domain/usecases/get_current_location.dart';
import 'features/home/domain/usecases/get_nearby_giveaways.dart';
import 'features/home/presentation/bloc/home_bloc.dart';

final GetIt sl = GetIt.instance;

/// Initializes the service locator and register dependencies.
Future<void> init() async {

  //! Features - Home
  // BLoCs
  sl.registerFactory<HomeBloc>(() => HomeBloc(getCurrentLocation: sl(), getNearbyGiveaways: sl()));

  // UseCases
  sl.registerLazySingleton<GetCurrentLocation>(()=>GetCurrentLocation(sl()));
  sl.registerLazySingleton<GetNearbyGiveaways>(() => GetNearbyGiveaways(sl()));

  // Repositories
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImplementation(sl()));

  // Data Sources
  sl.registerLazySingleton<HomeRemoteDatasource>(() => DeviceDatasource());

  //! Features - Giveaway
  // BLoCs
  sl.registerFactory<GiveawayBloc>(() => GiveawayBloc(
        getCurrentLocation: sl(),
        submitGiveaway: sl(),
      ));

  // UseCases
  sl.registerLazySingleton<GA.GetCurrentLocation>(()=>GA.GetCurrentLocation(sl()));
  sl.registerLazySingleton<SubmitGiveaway>(() => SubmitGiveaway(sl()));

  // Repositories
  sl.registerLazySingleton<GiveawayRepository>(() => GiveawayRepositoryImplementation(sl()));

  // Data Sources
  sl.registerLazySingleton<GiveawayRemoteDatasource>(() => GA.DeviceDatasource());

}

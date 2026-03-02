import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import 'package:stream_transform/stream_transform.dart';

import 'package:foodoid/core/domain/usecase.dart';
import '../../domain/entities/user_location_entity.dart';
import '../../domain/usecases/get_current_location.dart';

part 'home_event.dart';
part 'home_state.dart';

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

const throttleDuration = Duration(milliseconds: 100);

// Default location (Mumbai as example)
final defaultMumtaiLocation = const LatLng(19.0760, 72.8777);

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetCurrentLocation getCurrentLocation;

  HomeBloc({required this.getCurrentLocation}) : super(const HomeInitial()) {
    on<InitializeMapAndLocationEvent>(_onInitializeMapAndLocation);
    on<RequestLocationPermissionEvent>(_onRequestLocationPermission);
    on<GetCurrentLocationEvent>(_onGetCurrentLocation);
    on<RetryLocationEvent>(_onRetryLocation);
  }

  /// Initialize map and start location request flow
  Future<void> _onInitializeMapAndLocation(
    InitializeMapAndLocationEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(const MapLoading());
    
    // Simulate checking map network availability
    // In real scenario, you would check network connectivity here
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Map loaded successfully, now wait for location permission
    emit(
      MapLoadedWaitingPermission(
        defaultLocation: UserLocationEntity(
          latitude: defaultMumtaiLocation.latitude,
          longitude: defaultMumtaiLocation.longitude,
        ),
      ),
    );
    
    // Automatically request location permission
    add(const RequestLocationPermissionEvent());
  }

  /// Request location permission and fetch location
  Future<void> _onRequestLocationPermission(
    RequestLocationPermissionEvent event,
    Emitter<HomeState> emit,
  ) async {
    // Request current location
    add(const GetCurrentLocationEvent());
  }

  /// Fetch current location
  Future<void> _onGetCurrentLocation(
    GetCurrentLocationEvent event,
    Emitter<HomeState> emit,
  ) async {
    final result = await getCurrentLocation(NoParams());
    
    result.fold(
      (failure) {
        // Handle location failure
        final defaultLocation = UserLocationEntity(
          latitude: defaultMumtaiLocation.latitude,
          longitude: defaultMumtaiLocation.longitude,
        );
        
        if (failure.message.contains('Location permission')) {
          emit(
            LocationPermissionDenied(
              defaultLocation: defaultLocation,
              message: failure.message,
            ),
          );
        } else if (failure.message.contains('Network')) {
          emit(
            MapNetworkError(
              message: failure.message,
              lastKnownLocation: defaultLocation,
            ),
          );
        } else {
          emit(
            LocationError(
              message: failure.message,
              defaultLocation: defaultLocation,
            ),
          );
        }
      },
      (location) {
        // Location loaded successfully
        emit(LocationLoaded(location));
      },
    );
  }

  /// Retry location fetch
  Future<void> _onRetryLocation(
    RetryLocationEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(const MapLoading());
    add(const GetCurrentLocationEvent());
  }
}

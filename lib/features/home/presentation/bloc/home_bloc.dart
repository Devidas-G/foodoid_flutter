import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../core/domain/usecase.dart';
import '../../domain/entities/user_location_entity.dart';
import '../../domain/usecases/get_current_location.dart';
import '../../domain/usecases/get_nearby_giveaways.dart';
import '../../domain/entities/nearby_giveaway_entity.dart';

part 'home_event.dart';
part 'home_state.dart';

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

const throttleDuration = Duration(milliseconds: 100);

// Default location (Mumbai as example)
final defaultMumbaiLocation = const LatLng(19.0760, 72.8777);

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetCurrentLocation getCurrentLocation;
  final GetNearbyGiveaways getNearbyGiveaways;

  HomeBloc({required this.getCurrentLocation, required this.getNearbyGiveaways}) : super(const HomeInitial()) {
    on<InitializeMapAndLocationEvent>(_onInitializeMapAndLocation);
    on<RequestLocationPermissionEvent>(_onRequestLocationPermission);
    on<GetCurrentLocationEvent>(_onGetCurrentLocation);
    on<GetNearbyGiveawaysEvent>(_onGetNearbyGiveaways, transformer: throttleDroppable(throttleDuration));
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
          latitude: defaultMumbaiLocation.latitude,
          longitude: defaultMumbaiLocation.longitude,
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
          latitude: defaultMumbaiLocation.latitude,
          longitude: defaultMumbaiLocation.longitude,
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
      (location) async {
        // Location loaded successfully; emit location first
        emit(LocationLoaded(location));

        // Dispatch separate event to fetch nearby giveaways (keeps events separate)
        add(GetNearbyGiveawaysEvent(lat: location.latitude, lng: location.longitude));
      },
    );
  }

  /// Fetch nearby giveaways (separate event)
  Future<void> _onGetNearbyGiveaways(
    GetNearbyGiveawaysEvent event,
    Emitter<HomeState> emit,
  ) async {
    final result = await getNearbyGiveaways.call(NearbyParams(lat: event.lat, lng: event.lng));

    result.fold(
      (failure) {
        print('Failed to fetch nearby giveaways: ${failure.message}');
        // If failure, optionally emit a network error but keep existing location state
        final current = state;
        if (current is LocationLoaded) {
          emit(MapNetworkError(message: failure.message, lastKnownLocation: current.location));
          // Re-emit original location without nearby (after short delay) to avoid losing UI state
          emit(LocationLoaded(current.location));
        }
      },
      (giveaways) {
        print('Fetched ${giveaways.length} nearby giveaways');
        final current = state;
        if (current is LocationLoaded) {
          emit(LocationLoaded(current.location, nearbyGiveaways: giveaways));
        }
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

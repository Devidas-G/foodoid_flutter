import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import '../../giveaway_imports.dart';
import '../../../../core/domain/usecase.dart';
import '../../domain/use_cases/submit_giveaway.dart';
import '../../domain/entities/giveaway_entity.dart';
part 'giveaway_event.dart';
part 'giveaway_state.dart';

// Default location (Mumbai as example)
final defaultMumbaiLocation = const LatLng(19.0760, 72.8777);

class GiveawayBloc extends Bloc<GiveawayEvent, GiveawayState> {
  final GetCurrentLocation getCurrentLocation;
  final SubmitGiveaway submitGiveaway;

  GiveawayBloc({required this.getCurrentLocation, required this.submitGiveaway}) : super(GiveawayInitial()) {
    on<InitializeMapAndLocationEvent>(_onInitializeMapAndLocation);
    on<RequestLocationPermissionEvent>(_onRequestLocationPermission);
    on<GetCurrentLocationEvent>(_onGetCurrentLocation);
    on<RetryLocationEvent>(_onRetryLocation);
    on<SelectLocationEvent>(_onSelectLocation);
    on<SubmitGiveawayEvent>(_onSubmitGiveaway);
  }

  /// Initialize map and start location request flow
  Future<void> _onInitializeMapAndLocation(
    InitializeMapAndLocationEvent event,
    Emitter<GiveawayState> emit,
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
    Emitter<GiveawayState> emit,
  ) async {
    // Request current location
    add(const GetCurrentLocationEvent());
  }

  /// Fetch current location
  Future<void> _onGetCurrentLocation(
    GetCurrentLocationEvent event,
    Emitter<GiveawayState> emit,
  ) async {
    // Emit loading state if not already loading
    final currentState = state;
    if (!(currentState is LocationLoading)) {
      emit(LocationLoading(
        defaultLocation: currentState is MapLoadedWaitingPermission 
          ? currentState.defaultLocation 
          : null,
      ));
    }
    
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
      (location) {
        // Location loaded successfully
        emit(LocationLoaded(location));
      },
    );
  }

  /// Retry location fetch
  Future<void> _onRetryLocation(
    RetryLocationEvent event,
    Emitter<GiveawayState> emit,
  ) async {
    emit(const MapLoading());
    add(const GetCurrentLocationEvent());
  }

  /// Handle user selecting a location on the map
  Future<void> _onSelectLocation(
    SelectLocationEvent event,
    Emitter<GiveawayState> emit,
  ) async {
    emit(LocationLoaded(event.location));
  }

  Future<void> _onSubmitGiveaway(
    SubmitGiveawayEvent event,
    Emitter<GiveawayState> emit,
  ) async {
    emit(GiveawaySubmitting());
    final result = await submitGiveaway.call(event.giveaway);
    result.fold(
      (failure) => emit(GiveawaySubmitFailure(failure.message)),
      (_) => emit(GiveawaySubmitSuccess()),
    );
  }
}

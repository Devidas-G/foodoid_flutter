part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

/// Initial state - app just started, map not loaded yet
final class HomeInitial extends HomeState {
  const HomeInitial();
}

/// Map is loading from network
final class MapLoading extends HomeState {
  const MapLoading();
}

/// Map loaded successfully, waiting for location permission
final class MapLoadedWaitingPermission extends HomeState {
  final UserLocationEntity? defaultLocation;
  
  const MapLoadedWaitingPermission({this.defaultLocation});
  
  @override
  List<Object?> get props => [defaultLocation];
}

/// Location permission granted and location loaded
final class LocationLoaded extends HomeState {
  final UserLocationEntity location;

  const LocationLoaded(this.location);

  @override
  List<Object> get props => [location];
}

/// Location permission denied - showing default location
final class LocationPermissionDenied extends HomeState {
  final UserLocationEntity defaultLocation;
  final String message;

  const LocationPermissionDenied({
    required this.defaultLocation,
    required this.message,
  });

  @override
  List<Object> get props => [defaultLocation, message];
}

/// Network error while loading map
final class MapNetworkError extends HomeState {
  final String message;
  final UserLocationEntity? lastKnownLocation;

  const MapNetworkError({
    required this.message,
    this.lastKnownLocation,
  });

  @override
  List<Object?> get props => [message, lastKnownLocation];
}

/// Location fetch error
final class LocationError extends HomeState {
  final String message;
  final UserLocationEntity? defaultLocation;

  const LocationError({
    required this.message,
    this.defaultLocation,
  });

  @override
  List<Object?> get props => [message, defaultLocation];
}

/// Generic home error
final class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}

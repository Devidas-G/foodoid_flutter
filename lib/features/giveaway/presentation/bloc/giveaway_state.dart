part of 'giveaway_bloc.dart';


sealed class GiveawayState extends Equatable {
  const GiveawayState();
  
  @override
  List<Object?> get props => [];
}

final class GiveawayInitial extends GiveawayState {}

/// Map is loading from network
final class MapLoading extends GiveawayState {
  const MapLoading();
}

/// Map loaded successfully, waiting for location permission
final class MapLoadedWaitingPermission extends GiveawayState {
  final UserLocationEntity? defaultLocation;
  
  const MapLoadedWaitingPermission({this.defaultLocation});
  
  @override
  List<Object?> get props => [defaultLocation];
}

/// Location is currently being fetched
final class LocationLoading extends GiveawayState {
  final UserLocationEntity? defaultLocation;
  
  const LocationLoading({this.defaultLocation});
  
  @override
  List<Object?> get props => [defaultLocation];
}

/// Location permission granted and location loaded
final class LocationLoaded extends GiveawayState {
  final UserLocationEntity location;

  const LocationLoaded(this.location);

  @override
  List<Object> get props => [location];
}

/// Location permission denied - showing default location
final class LocationPermissionDenied extends GiveawayState {
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
final class MapNetworkError extends GiveawayState {
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
final class LocationError extends GiveawayState {
  final String message;
  final UserLocationEntity? defaultLocation;

  const LocationError({
    required this.message,
    this.defaultLocation,
  });

  @override
  List<Object?> get props => [message, defaultLocation];
}

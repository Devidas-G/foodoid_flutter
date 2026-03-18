part of 'giveaway_bloc.dart';

sealed class GiveawayEvent extends Equatable {
  const GiveawayEvent();

  @override
  List<Object> get props => [];
}

/// Initialize map and request location
class InitializeMapAndLocationEvent extends GiveawayEvent {
  const InitializeMapAndLocationEvent();
}

/// Request location permission
class RequestLocationPermissionEvent extends GiveawayEvent {
  const RequestLocationPermissionEvent();
}

/// Fetch current user location
class GetCurrentLocationEvent extends GiveawayEvent {
  const GetCurrentLocationEvent();
}

/// Retry location fetch
class RetryLocationEvent extends GiveawayEvent {
  const RetryLocationEvent();
}

/// User selected a location on the map
class SelectLocationEvent extends GiveawayEvent {
  final UserLocationEntity location;

  const SelectLocationEvent(this.location);

  @override
  List<Object> get props => [location];
}

/// Submit giveaway form
class SubmitGiveawayEvent extends GiveawayEvent {
  final GiveawayEntity giveaway;

  const SubmitGiveawayEvent(this.giveaway);

  @override
  List<Object> get props => [giveaway];
}
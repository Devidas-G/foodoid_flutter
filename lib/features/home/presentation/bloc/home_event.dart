part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

/// Initialize map and request location
class InitializeMapAndLocationEvent extends HomeEvent {
  const InitializeMapAndLocationEvent();
}

/// Request location permission
class RequestLocationPermissionEvent extends HomeEvent {
  const RequestLocationPermissionEvent();
}

/// Fetch current user location
class GetCurrentLocationEvent extends HomeEvent {
  const GetCurrentLocationEvent();
}

/// Retry location fetch
class RetryLocationEvent extends HomeEvent {
  const RetryLocationEvent();
}
import 'package:equatable/equatable.dart';

enum LocationPermissionStatus { granted, denied, deniedForever }

class LocationPermissionEntity extends Equatable {
  final LocationPermissionStatus status;
  final String? message;

  const LocationPermissionEntity({
    required this.status,
    this.message,
  });

  @override
  List<Object?> get props => [status, message];
}

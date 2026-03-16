import '../../domain/entities/user_location_entity.dart';

class UserLocation extends UserLocationEntity {
  UserLocation({required super.latitude, required super.longitude});
  factory UserLocation.fromJson(Map<String, dynamic> json) {
    return UserLocation(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'latitude': latitude, 'longitude': longitude};
  }
}

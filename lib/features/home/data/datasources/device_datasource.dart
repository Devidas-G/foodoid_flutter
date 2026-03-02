import 'package:geolocator/geolocator.dart';

import 'package:foodoid/core/errors/exception.dart';
import '../models/user_location.dart';
import 'home_datasource.dart';

class DeviceDatasource implements HomeRemoteDatasource {
  @override
  Future<UserLocation> fetchCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw CustomException('Location services are disabled.');
      }

      // Request location permission
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw CustomException('Location permission is denied.');
      } else if (permission == LocationPermission.deniedForever) {
        throw CustomException(
            'Location permission is denied forever. Please enable it in settings.');
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return UserLocation(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } on CustomException {
      rethrow;
    } catch (e) {
      throw CustomException('Failed to get current location: ${e.toString()}');
    }
  }
}
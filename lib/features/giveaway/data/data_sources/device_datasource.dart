import 'dart:convert';

import 'package:geolocator/geolocator.dart';

import 'package:foodoid/core/errors/exception.dart';
import 'package:foodoid/core/api/api.dart';
import '../models/user_location.dart';
import 'giveaway_datasource.dart';
import '../models/giveaway_model.dart';

class DeviceDatasource implements GiveawayRemoteDatasource {
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

  @override
  Future<void> submitGiveaway(GiveawayModel giveaway) async {
    try {
      // Use ApiClient with baseUrl and configured headers (including api-key)
      final response = await ApiClient.instance
          .post('api/private/foodoid/create', body: giveaway.toJson());

      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          final Map<String, dynamic> jsonBody = json.decode(response.body);
          if (jsonBody.containsKey('success')) {
            final successFlag = jsonBody['success'];
            if (successFlag is bool && !successFlag) {
              final msg = jsonBody['message']?.toString() ?? 'Submission failed';
              throw CustomException('Failed to submit giveaway: $msg');
            }
          }
          return;
        } catch (e) {
          return;
        }
      } else {
        throw CustomException(
            'Failed to submit giveaway: ${response.statusCode} ${response.body}');
      }
    } on CustomException {
      rethrow;
    } catch (e) {
      throw CustomException('Failed to submit giveaway: ${e.toString()}');
    }
  }
}
import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'package:foodoid/core/errors/exception.dart';
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
      // Example URL - replace with real endpoint later
      final uri = Uri.parse('https://example.com/api/giveaways');
      final headers = {'Content-Type': 'application/json'};
      final body = json.encode(giveaway.toJson());

      final response = await http.post(uri, headers: headers, body: body).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Try to parse response body for explicit success/message fields.
        try {
          final Map<String, dynamic> jsonBody = json.decode(response.body);
          // If API returns explicit success flag, respect it.
          if (jsonBody.containsKey('success')) {
            final successFlag = jsonBody['success'];
            if (successFlag is bool && !successFlag) {
              final msg = jsonBody['message']?.toString() ?? 'Submission failed';
              throw CustomException('Failed to submit giveaway: $msg');
            }
          }
          // Otherwise assume 2xx means success.
          return;
        } catch (e) {
          // If response is not JSON or parsing failed, assume success for 2xx.
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
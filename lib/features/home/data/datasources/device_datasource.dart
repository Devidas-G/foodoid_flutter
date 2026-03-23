import 'dart:convert';

import 'package:geolocator/geolocator.dart';

import 'package:foodoid/core/errors/exception.dart';
import 'package:foodoid/core/api/api_client.dart';
import '../models/user_location.dart';
import '../models/nearby_giveaway_model.dart';
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

  @override
  Future<List<NearbyGiveawayModel>> fetchNearbyGiveaways(
    double lat,
    double lng, {
    List<String>? status,
    List<String>? foodType,
  }) async {
    try {
      final path = 'api/private/foodoid/nearby?lat=$lat&lng=$lng';

      final body = {
        'filters': {
          'status': ?status,
          'foodType': ?foodType,
        }
      };

      // If no filters provided, send empty body to be safe
      final response = await ApiClient.instance.post(path, body: body);
      print(response.statusCode);
      print(response.body);


      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          return decoded
              .map<NearbyGiveawayModel>((e) => NearbyGiveawayModel.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        } else if (decoded is Map && decoded['data'] is List) {
          return (decoded['data'] as List)
              .map<NearbyGiveawayModel>((e) => NearbyGiveawayModel.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        } else {
          // API returned empty list or unexpected shape
          return <NearbyGiveawayModel>[];
        }
      } else {
        throw CustomException('Network error: ${response.statusCode}');
      }
    } on CustomException {
      rethrow;
    } catch (e) {
      throw CustomException('Failed to fetch nearby giveaways: ${e.toString()}');
    }
  }
}
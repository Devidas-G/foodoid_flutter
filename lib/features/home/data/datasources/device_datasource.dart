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
  Future<List<NearbyGiveawayModel>> fetchNearbyGiveaways(double lat, double lng) async {
    try {
      final path = 'api/private/foodoid/nearby?lat=$lat&lng=$lng';
      final response = await ApiClient.instance.get(path);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        print(response.body);
        if (body is List) {
          return body
              .map<NearbyGiveawayModel>((e) => NearbyGiveawayModel.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        } else if (body is Map && body['data'] is List) {
          return (body['data'] as List)
              .map<NearbyGiveawayModel>((e) => NearbyGiveawayModel.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        } else {
          throw CustomException('Unexpected response format from nearby API');
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
import '../../domain/entities/nearby_giveaway_entity.dart';

class NearbyGiveawayModel extends NearbyGiveawayEntity {
  NearbyGiveawayModel({
    required super.title,
    required super.coordinates,
    required super.startTime,
    required super.endTime,
    super.foodType,
    required super.address,
    required super.quantityEstimate,
  });

  factory NearbyGiveawayModel.fromJson(Map<String, dynamic> json) {
    // Extract coordinates. API returns GeoJSON-style location.coordinates = [lng, lat]
    // Normalize to [lat, lng] which is what flutter_map LatLng expects
    List<double> coords = [];
    try {
      final rawCoords = json['location'] != null && json['location']['coordinates'] is List
          ? List.from(json['location']['coordinates'])
          : (json['coordinates'] is List ? List.from(json['coordinates']) : []);

      coords = rawCoords.map<double>((e) => (e as num).toDouble()).toList();
      if (coords.length == 2) {
        // assume API gives [lng, lat] (GeoJSON) and convert to [lat, lng]
        coords = [coords[1], coords[0]];
      }
    } catch (_) {
      coords = [];
    }

    DateTime parseDate(dynamic v) {
      if (v == null) return DateTime.now();
      if (v is String) return DateTime.parse(v);
      if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
      return DateTime.now();
    }

    return NearbyGiveawayModel(
      title: json['title'] ?? '',
      coordinates: coords,
      startTime: parseDate(json['startTime'] ?? json['start_time']),
      endTime: parseDate(json['endTime'] ?? json['end_time']),
      foodType: json['foodType'] ?? json['type'],
      address: json['address'] ?? json['location_name'] ?? '',
      quantityEstimate: (json['quantityEstimate'] ?? json['confirmCount'] ?? 0) is int
          ? (json['quantityEstimate'] ?? json['confirmCount'] ?? 0)
          : int.tryParse((json['quantityEstimate'] ?? json['confirmCount'] ?? '0').toString()) ?? 0,
    );
  }

  NearbyGiveawayEntity toEntity() => NearbyGiveawayEntity(
        title: title,
        coordinates: coordinates,
        startTime: startTime,
        endTime: endTime,
        foodType: foodType,
        address: address,
        quantityEstimate: quantityEstimate,
      );
}

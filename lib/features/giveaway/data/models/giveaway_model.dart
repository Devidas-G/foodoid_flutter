import '../../domain/entities/giveaway_entity.dart';

class GiveawayModel extends GiveawayEntity {
  GiveawayModel({
    required super.title,
    required super.coordinates,
    required super.startTime,
    required super.endTime,
    super.foodType,
    required super.address,
    required super.quantityEstimate,
  });

  factory GiveawayModel.fromEntity(GiveawayEntity e) => GiveawayModel(
        title: e.title,
        coordinates: e.coordinates,
        startTime: e.startTime,
        endTime: e.endTime,
        foodType: e.foodType,
        address: e.address,
        quantityEstimate: e.quantityEstimate,
      );

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'location': {
        'type': 'Point',
        'coordinates': coordinates,
      },
      'startTime': startTime.toUtc().toIso8601String(),
      'endTime': endTime.toUtc().toIso8601String(),
      'foodType': foodType,
      'address': address,
      'quantityEstimate': quantityEstimate,
    };
  }
}

class NearbyGiveawayEntity {
  final String title;
  final List<double> coordinates; // [latitude, longitude] or [longitude, latitude]
  final DateTime startTime;
  final DateTime endTime;
  final String? foodType;
  final String address;
  final int quantityEstimate;

  NearbyGiveawayEntity({
    required this.title,
    required this.coordinates,
    required this.startTime,
    required this.endTime,
    this.foodType,
    required this.address,
    required this.quantityEstimate,
  });
}

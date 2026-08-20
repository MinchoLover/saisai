class CandidatePlace {
  const CandidatePlace({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.stayMinutes,
    required this.detourMinutes,
    required this.rating,
    required this.imageEmoji,
    this.imageUrl,
    this.address = '',
    this.latitude = 0,
    this.longitude = 0,
    this.distanceMeters = 0,
  });

  final String id;
  final String name;
  final String category;
  final String description;
  final int stayMinutes;
  final int detourMinutes;
  final double rating;
  final String imageEmoji;
  final String? imageUrl;
  final String address;
  final double latitude;
  final double longitude;
  final int distanceMeters;

  int get requiredMinutes => stayMinutes + detourMinutes;
}

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
  });

  final String id;
  final String name;
  final String category;
  final String description;
  final int stayMinutes;
  final int detourMinutes;
  final double rating;
  final String imageEmoji;

  int get requiredMinutes => stayMinutes + detourMinutes;
}

class SearchCondition {
  const SearchCondition({
    required this.startName,
    required this.destinationName,
    required this.availableMinutes,
    this.categories = const [],
    this.travelMode = '도보',
  });

  final String startName;
  final String destinationName;
  final int availableMinutes;
  final List<String> categories;
  final String travelMode;

  SearchCondition copyWith({
    int? availableMinutes,
    List<String>? categories,
    String? travelMode,
  }) =>
      SearchCondition(
        startName: startName,
        destinationName: destinationName,
        availableMinutes: availableMinutes ?? this.availableMinutes,
        categories: categories ?? this.categories,
        travelMode: travelMode ?? this.travelMode,
      );
}

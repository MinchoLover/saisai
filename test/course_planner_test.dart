import 'package:flutter_test/flutter_test.dart';
import 'package:saisai/data/mock_tour_repository.dart';
import 'package:saisai/models/search_condition.dart';
import 'package:saisai/services/course_planner.dart';

void main() {
  test('feasible filter excludes candidates that exceed available time', () {
    const condition = SearchCondition(
      startName: '서울역',
      destinationName: '광화문',
      availableMinutes: 45,
      categories: ['산책', '전시'],
    );
    final places = const MockTourRepository().candidatesFor(condition);
    final feasible = CoursePlanner().feasibleCandidates(condition, places);

    expect(feasible.map((place) => place.name), contains('서울로7017'));
    expect(feasible.every((place) => place.requiredMinutes <= 45), isTrue);
  });
}

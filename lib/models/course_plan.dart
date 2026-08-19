import 'candidate_place.dart';
import 'search_condition.dart';

class CoursePlan {
  const CoursePlan({
    required this.condition,
    required this.places,
    required this.totalRequiredMinutes,
    required this.remainingMinutes,
  });

  final SearchCondition condition;
  final List<CandidatePlace> places;
  final int totalRequiredMinutes;
  final int remainingMinutes;
}

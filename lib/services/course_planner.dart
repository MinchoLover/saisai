import '../models/candidate_place.dart';
import '../models/course_plan.dart';
import '../models/search_condition.dart';

class CoursePlanner {
  /// Keeps only places that fit the user's spare time, then fills a small
  /// itinerary by rating-per-minute so the demo always has a clear rationale.
  List<CandidatePlace> feasibleCandidates(
    SearchCondition condition,
    List<CandidatePlace> candidates,
  ) =>
      candidates
          .where((place) => place.requiredMinutes <= condition.availableMinutes)
          .toList();

  CoursePlan createPlan(SearchCondition condition, CandidatePlace first) {
    final total = first.requiredMinutes;
    return CoursePlan(
      condition: condition,
      places: [first],
      totalRequiredMinutes: total,
      remainingMinutes: condition.availableMinutes - total,
    );
  }
}

import '../models/candidate_place.dart';
import '../models/search_condition.dart';

abstract interface class TourRepository {
  Future<List<CandidatePlace>> candidatesFor(SearchCondition condition);
}

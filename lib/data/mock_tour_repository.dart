import '../models/candidate_place.dart';
import '../models/search_condition.dart';

class MockTourRepository {
  const MockTourRepository();

  List<CandidatePlace> candidatesFor(SearchCondition condition) {
    const places = [
      CandidatePlace(
          id: 'seoullo',
          name: '서울로7017',
          category: '산책',
          description: '서울역 위를 걷는 공중 보행길. 도심 풍경과 식물을 함께 만나요.',
          stayMinutes: 35,
          detourMinutes: 10,
          rating: 4.8,
          imageEmoji: '🌿'),
      CandidatePlace(
          id: 'museum',
          name: '서울시립미술관',
          category: '전시',
          description: '덕수궁 돌담길 곁에서 만나는 현대미술 전시 공간입니다.',
          stayMinutes: 60,
          detourMinutes: 20,
          rating: 4.7,
          imageEmoji: '🖼️'),
      CandidatePlace(
          id: 'market',
          name: '남대문시장',
          category: '맛집',
          description: '시장 골목에서 서울의 활기와 간단한 먹거리를 즐겨 보세요.',
          stayMinutes: 45,
          detourMinutes: 15,
          rating: 4.6,
          imageEmoji: '🥟'),
      CandidatePlace(
          id: 'palace',
          name: '덕수궁',
          category: '역사',
          description: '고궁과 돌담길을 따라 잠시 여유를 갖기 좋은 장소입니다.',
          stayMinutes: 50,
          detourMinutes: 18,
          rating: 4.9,
          imageEmoji: '🏯'),
      CandidatePlace(
          id: 'cafe',
          name: '서소문성지 역사박물관',
          category: '역사',
          description: '조용하게 전시를 둘러보며 잠깐 쉬어갈 수 있습니다.',
          stayMinutes: 40,
          detourMinutes: 12,
          rating: 4.5,
          imageEmoji: '🏛️'),
    ];
    if (condition.categories.isEmpty) return places;
    return places
        .where((p) => condition.categories.contains(p.category))
        .toList();
  }
}

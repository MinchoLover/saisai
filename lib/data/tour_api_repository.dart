import 'dart:convert';
import 'dart:math' as math;

import 'package:http/http.dart' as http;

import '../core/api/tour_api_config.dart';
import '../models/candidate_place.dart';
import '../models/search_condition.dart';
import 'tour_repository.dart';

class TourApiException implements Exception {
  const TourApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class TourApiRepository implements TourRepository {
  TourApiRepository({http.Client? client, String? serviceKey})
      : _client = client ?? http.Client(),
        _serviceKey = serviceKey ?? TourApiConfig.serviceKey;

  static const _host = 'apis.data.go.kr';
  static const _path = '/B551011/KorService2/locationBasedList2';
  static const _defaultLongitude = 126.9707;
  static const _defaultLatitude = 37.5547;

  final http.Client _client;
  final String _serviceKey;

  @override
  Future<List<CandidatePlace>> candidatesFor(
    SearchCondition condition,
  ) async {
    if (_serviceKey.trim().isEmpty) {
      throw const TourApiException('관광공사 API 키가 설정되지 않았습니다.');
    }

    final uri = Uri.https(_host, _path, {
      'serviceKey': _serviceKey,
      'MobileOS': 'ETC',
      'MobileApp': TourApiConfig.mobileApp,
      '_type': 'json',
      'mapX': '$_defaultLongitude',
      'mapY': '$_defaultLatitude',
      'radius': '5000',
      'arrange': 'E',
      'numOfRows': '50',
      'pageNo': '1',
    });

    final response =
        await _client.get(uri).timeout(const Duration(seconds: 12));
    if (response.statusCode != 200) {
      throw TourApiException('관광정보를 불러오지 못했습니다. (${response.statusCode})');
    }

    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    if (decoded is! Map<String, dynamic>) {
      throw const TourApiException('관광정보 응답 형식이 올바르지 않습니다.');
    }

    final apiResponse = decoded['response'] as Map<String, dynamic>?;
    final header = apiResponse?['header'] as Map<String, dynamic>?;
    if (header?['resultCode']?.toString() != '0000') {
      throw TourApiException(
        header?['resultMsg']?.toString() ?? '관광공사 API 요청에 실패했습니다.',
      );
    }

    final body = apiResponse?['body'] as Map<String, dynamic>?;
    final itemsContainer = body?['items'];
    if (itemsContainer == '' || itemsContainer == null) return const [];
    final itemValue = (itemsContainer as Map<String, dynamic>)['item'];
    final Iterable<Map<String, dynamic>> items = switch (itemValue) {
      List<dynamic> values => values.whereType<Map<String, dynamic>>(),
      Map<String, dynamic> value => [value],
      _ => const <Map<String, dynamic>>[],
    };

    return items
        .map(_candidateFromJson)
        .where((place) =>
            condition.categories.isEmpty ||
            condition.categories.contains(place.category))
        .toList();
  }

  CandidatePlace _candidateFromJson(Map<String, dynamic> json) {
    final contentTypeId = json['contenttypeid']?.toString() ?? '';
    final distanceMeters = _asDouble(json['dist']);
    final address = [json['addr1'], json['addr2']]
        .where((part) => part != null && part.toString().trim().isNotEmpty)
        .join(' ');

    return CandidatePlace(
      id: json['contentid']?.toString() ?? '',
      name: json['title']?.toString() ?? '이름 없는 장소',
      category: _categoryFor(contentTypeId),
      description: address.isEmpty ? '상세 정보를 확인해 보세요.' : address,
      stayMinutes: _stayMinutesFor(contentTypeId),
      detourMinutes: math.max(5, (distanceMeters / 65).ceil()),
      rating: 0,
      imageEmoji: _emojiFor(contentTypeId),
      imageUrl: _nonEmpty(json['firstimage']) ?? _nonEmpty(json['firstimage2']),
      address: address,
      latitude: _asDouble(json['mapy']),
      longitude: _asDouble(json['mapx']),
      distanceMeters: distanceMeters.round(),
    );
  }

  String _categoryFor(String type) => switch (type) {
        '12' => '산책',
        '14' => '전시',
        '15' => '문화',
        '28' => '레포츠',
        '32' => '숙박',
        '38' => '쇼핑',
        '39' => '맛집',
        _ => '관광',
      };

  int _stayMinutesFor(String type) => switch (type) {
        '14' => 60,
        '15' => 90,
        '28' => 90,
        '32' => 60,
        '38' => 45,
        '39' => 50,
        _ => 45,
      };

  String _emojiFor(String type) => switch (type) {
        '14' => '🖼️',
        '15' => '🎭',
        '28' => '🚲',
        '32' => '🏨',
        '38' => '🛍️',
        '39' => '🍽️',
        _ => '📍',
      };

  double _asDouble(Object? value) =>
      double.tryParse(value?.toString() ?? '') ?? 0;

  String? _nonEmpty(Object? value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? null : text;
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:saisai/data/tour_api_repository.dart';
import 'package:saisai/models/search_condition.dart';

void main() {
  test('location response is converted to candidate places', () async {
    final client = MockClient((request) async {
      return http.Response(
        '''
        {
          "response": {
            "header": {"resultCode": "0000", "resultMsg": "OK"},
            "body": {
              "items": {
                "item": [{
                  "contentid": "123",
                  "contenttypeid": "39",
                  "title": "테스트 식당",
                  "addr1": "서울 중구",
                  "mapx": "126.97",
                  "mapy": "37.55",
                  "dist": "650",
                  "firstimage": "https://example.com/image.jpg"
                }]
              }
            }
          }
        }
        ''',
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    });

    final places = await TourApiRepository(
      client: client,
      serviceKey: 'test-key',
    ).candidatesFor(
      const SearchCondition(
        startName: '서울역',
        destinationName: '광화문',
        availableMinutes: 90,
        categories: ['맛집'],
      ),
    );

    expect(places, hasLength(1));
    expect(places.single.name, '테스트 식당');
    expect(places.single.category, '맛집');
    expect(places.single.detourMinutes, 10);
    expect(places.single.imageUrl, 'https://example.com/image.jpg');
  });
}

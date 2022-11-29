import 'dart:convert';
import 'package:feature_tv/data/models/tv_model.dart';
import 'package:feature_tv/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helper/json_reader.dart';

void main() {
  final tTVModel = TVModel(
    backdropPath: '/3XjDhPzj7Myr8yzsTO8UB6E2oAu.jpg',
    firstAirDate: DateTime.parse("2011-07-24"),
    genreIds: const [18, 80],
    id: 31586,
    name: 'La Reina del Sur',
    originCountry: const ['US'],
    originalLanguage: 'es',
    originalName: 'La Reina del Sur',
    overview:
        'After years of blood, sweat and tears, a woman of humble origin ends up becoming a drug trafficking legend, with all that that means...',
    popularity: 3668.16,
    posterPath: '/p11t8ckTC6EiuVw5FGFKdc2Z7GH.jpg',
    voteAverage: 7.8,
    voteCount: 1375,
  );

  final tTVResponseModel = TVResponse(
    page: 1,
    results: <TVModel>[tTVModel],
    totalPages: 1,
    totalResults: 1,
  );

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('helper/dummy_data/tv_on_the_air.json'));
      // act
      final result = TVResponse.fromJson(jsonMap);
      // assert
      expect(result, tTVResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tTVResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "page": 1,
        "results": [
          {
            "backdrop_path": "/3XjDhPzj7Myr8yzsTO8UB6E2oAu.jpg",
            "first_air_date": "2011-07-24",
            "genre_ids": [18, 80],
            "id": 31586,
            "name": "La Reina del Sur",
            "origin_country": ["US"],
            "original_language": "es",
            "original_name": "La Reina del Sur",
            "overview":
                "After years of blood, sweat and tears, a woman of humble origin ends up becoming a drug trafficking legend, with all that that means...",
            "popularity": 3668.16,
            "poster_path": "/p11t8ckTC6EiuVw5FGFKdc2Z7GH.jpg",
            "vote_average": 7.8,
            "vote_count": 1375
          }
        ],
        "total_pages": 1,
        "total_results": 1
      };
      expect(result, expectedJsonMap);
    });
  });
}

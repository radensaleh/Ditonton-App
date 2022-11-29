import 'dart:convert';
import 'dart:io';
import 'package:core/core.dart';
import 'package:feature_tv/data/datasource/tv_remote_data_source.dart';
import 'package:feature_tv/data/models/tv_detail_response.dart';
import 'package:feature_tv/data/models/tv_response.dart';
import 'package:feature_tv/data/models/tv_season/season_detail_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import '../../helper/json_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late TVRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TVRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get On The Air TV Shows', () {
    final tTVList = TVResponse.fromJson(
            json.decode(readJson('helper/dummy_data/tv_on_the_air.json')))
        .results;

    test('should return list of TV Model when the response code is 200',
        () async {
      // arrange
      when(() =>
              mockHttpClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('helper/dummy_data/tv_on_the_air.json'), 200));
      // act
      final result = await dataSource.getOnTheAirTVShows();
      // assert
      expect(result, equals(tTVList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(() =>
              mockHttpClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getOnTheAirTVShows();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Popular TV Shows', () {
    final tTVList = TVResponse.fromJson(
            json.decode(readJson('helper/dummy_data/tv_popular.json')))
        .results;

    test('should return list of tv shows when response is success (200)',
        () async {
      // arrange
      when(() => mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('helper/dummy_data/tv_popular.json'), 200));
      // act
      final result = await dataSource.getPopularTVShows();
      // assert
      expect(result, tTVList);
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(() => mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getPopularTVShows();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Top Rated TV', () {
    final tTVList = TVResponse.fromJson(
            json.decode(readJson('helper/dummy_data/tv_top_rated.json')))
        .results;

    test('should return list of tv when response code is 200 ', () async {
      // arrange
      when(() =>
              mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('helper/dummy_data/tv_top_rated.json'), 200));
      // act
      final result = await dataSource.getTopRatedTVShows();
      // assert
      expect(result, tTVList);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      // arrange
      when(() =>
              mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTopRatedTVShows();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get TV Detail', () {
    const tId = 1;
    final tTVDetail = TvDetailResponse.fromJson(
        json.decode(readJson('helper/dummy_data/tv_detail.json')));

    test('should return tv detail when the response code is 200', () async {
      // arrange
      when(() => mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer(
        (_) async => http.Response(
          readJson('helper/dummy_data/tv_detail.json'),
          200,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
          },
        ),
      );
      // act
      final result = await dataSource.getTVShowDetail(tId);
      // assert
      expect(result, equals(tTVDetail));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      when(() => mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTVShowDetail(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get TV Recommendations', () {
    final tTVList = TVResponse.fromJson(
            json.decode(readJson('helper/dummy_data/tv_recommendations.json')))
        .results;
    const tId = 1;

    test('should return list of TV Model when the response code is 200',
        () async {
      // arrange
      when(() => mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('helper/dummy_data/tv_recommendations.json'), 200));
      // act
      final result = await dataSource.getTVShowRecommendations(tId);
      // assert
      expect(result, equals(tTVList));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      when(() => mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTVShowRecommendations(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('search TV Shows', () {
    final tSearchResult = TVResponse.fromJson(
            json.decode(readJson('helper/dummy_data/tv_search.json')))
        .results;
    const tQuery = 'La Reina del';

    test('should return list of tv when response code is 200', () async {
      // arrange
      when(() => mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async =>
              http.Response(readJson('helper/dummy_data/tv_search.json'), 200));
      // act
      final result = await dataSource.searchTVShows(tQuery);
      // assert
      expect(result, tSearchResult);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      // arrange
      when(() => mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.searchTVShows(tQuery);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get TV Season Detail', () {
    const tId = 1;
    const tSeasonNumber = 1;
    final tTVSeasonDetail = SeasonDetailResponse.fromJson(
        json.decode(readJson('helper/dummy_data/tv_season_detail.json')));

    test('should return tv seasone detail when the response code is 200',
        () async {
      // arrange
      when(() => mockHttpClient.get(
              Uri.parse('$BASE_URL/tv/$tId/season/$tSeasonNumber?$API_KEY')))
          .thenAnswer(
        (_) async => http.Response(
          readJson('helper/dummy_data/tv_season_detail.json'),
          200,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
          },
        ),
      );
      // act
      final result = await dataSource.getSeasonDetail(tId, tSeasonNumber);
      // assert
      expect(result, equals(tTVSeasonDetail));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      when(() => mockHttpClient.get(
              Uri.parse('$BASE_URL/tv/$tId/season/$tSeasonNumber?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getSeasonDetail(tId, tSeasonNumber);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}

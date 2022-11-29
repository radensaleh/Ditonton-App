import 'dart:convert';

import 'package:core/core.dart';
import 'package:feature_tv/data/models/tv_detail_response.dart';
import 'package:feature_tv/data/models/tv_model.dart';
import 'package:feature_tv/data/models/tv_response.dart';
import 'package:feature_tv/data/models/tv_season/season_detail_response.dart';
import 'package:http/http.dart' as http;

abstract class TVRemoteDataSource {
  Future<List<TVModel>> getOnTheAirTVShows();
  Future<List<TVModel>> getPopularTVShows();
  Future<List<TVModel>> getTopRatedTVShows();
  Future<TvDetailResponse> getTVShowDetail(int id);
  Future<List<TVModel>> getTVShowRecommendations(int id);
  Future<List<TVModel>> searchTVShows(String query);
  Future<SeasonDetailResponse> getSeasonDetail(int tvId, int seasonNumber);
}

class TVRemoteDataSourceImpl implements TVRemoteDataSource {
  static const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  static const BASE_URL = 'https://api.themoviedb.org/3';

  final http.Client client;

  TVRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TVModel>> getOnTheAirTVShows() async {
    final response =
        await client.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY'));

    if (response.statusCode == 200) {
      return TVResponse.fromJson(json.decode(response.body)).results;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TVModel>> getPopularTVShows() async {
    final response =
        await client.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY'));

    if (response.statusCode == 200) {
      return TVResponse.fromJson(json.decode(response.body)).results;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvDetailResponse> getTVShowDetail(int id) async {
    final response = await client.get(Uri.parse('$BASE_URL/tv/$id?$API_KEY'));

    if (response.statusCode == 200) {
      return TvDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TVModel>> getTVShowRecommendations(int id) async {
    final response = await client
        .get(Uri.parse('$BASE_URL/tv/$id/recommendations?$API_KEY'));

    if (response.statusCode == 200) {
      return TVResponse.fromJson(json.decode(response.body)).results;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TVModel>> getTopRatedTVShows() async {
    final response =
        await client.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY'));

    if (response.statusCode == 200) {
      return TVResponse.fromJson(json.decode(response.body)).results;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TVModel>> searchTVShows(String query) async {
    final response = await client
        .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$query'));

    if (response.statusCode == 200) {
      return TVResponse.fromJson(json.decode(response.body)).results;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<SeasonDetailResponse> getSeasonDetail(
      int tvId, int seasonNumber) async {
    final response = await client
        .get(Uri.parse('$BASE_URL/tv/$tvId/season/$seasonNumber?$API_KEY'));

    if (response.statusCode == 200) {
      return SeasonDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}

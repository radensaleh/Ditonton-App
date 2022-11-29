import 'dart:io';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:feature_tv/data/datasource/tv_local_data_source.dart';
import 'package:feature_tv/data/datasource/tv_remote_data_source.dart';
import 'package:feature_tv/data/models/genre_model.dart';
import 'package:feature_tv/data/models/last_episode_to_air_model.dart';
import 'package:feature_tv/data/models/network_model.dart';
import 'package:feature_tv/data/models/season_model.dart';
import 'package:feature_tv/data/models/spoken_language_model.dart';
import 'package:feature_tv/data/models/tv_detail_response.dart';
import 'package:feature_tv/data/models/tv_model.dart';
import 'package:feature_tv/data/models/tv_season/episode_model.dart';
import 'package:feature_tv/data/models/tv_season/season_detail_response.dart';
import 'package:feature_tv/data/repositories/tv_repository_impl.dart';
import 'package:feature_tv/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/dummy_data/dummy_objects.dart';

class MockTVRemoteDataSource extends Mock implements TVRemoteDataSource {}

class MockTVLocalDataSource extends Mock implements TVLocalDataSource {}

void main() {
  late TVRepositoryImpl repository;
  late MockTVRemoteDataSource mockRemoteDataSource;
  late MockTVLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTVRemoteDataSource();
    mockLocalDataSource = MockTVLocalDataSource();
    repository = TVRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  const tTVShowModel = TVModel(
    backdropPath: 'backdropPath',
    firstAirDate: null,
    genreIds: [1, 2, 3],
    id: 1,
    name: 'name',
    originCountry: ['originCountry'],
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 21.1,
    posterPath: 'posterPath',
    voteAverage: 11.2,
    voteCount: 22,
  );

  final tTVShow = TV(
    backdropPath: 'backdropPath',
    firstAirDate: null,
    genreIds: const [1, 2, 3],
    id: 1,
    name: 'name',
    originCountry: const ['originCountry'],
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 21.1,
    posterPath: 'posterPath',
    voteAverage: 11.2,
    voteCount: 22,
  );

  final tTVModelList = <TVModel>[tTVShowModel];
  final tTVList = <TV>[tTVShow];

  group('On The Air TV Shows', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(() => mockRemoteDataSource.getOnTheAirTVShows())
          .thenAnswer((_) async => tTVModelList);
      // act
      final result = await repository.getOnTheAirTVShows();
      // assert
      verify(() => mockRemoteDataSource.getOnTheAirTVShows());
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVList);
    });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(() => mockRemoteDataSource.getOnTheAirTVShows())
          .thenThrow(ServerException());
      // act
      final result = await repository.getOnTheAirTVShows();
      // assert
      verify(() => mockRemoteDataSource.getOnTheAirTVShows());
      expect(result, equals(const Left(ServerFailure(''))));
    });
  });

  group('Popular TV Shows', () {
    test('should return tv show list when call to data source is success',
        () async {
      // arrange
      when(() => mockRemoteDataSource.getPopularTVShows())
          .thenAnswer((_) async => tTVModelList);
      // act
      final result = await repository.getPopularTVShows();
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVList);
    });

    test(
        'should return server failure when call to data source is unsuccessful',
        () async {
      // arrange
      when(() => mockRemoteDataSource.getPopularTVShows())
          .thenThrow(ServerException());
      // act
      final result = await repository.getPopularTVShows();
      // assert
      expect(result, const Left(ServerFailure('')));
    });

    test(
        'should return connection failure when device is not connected to the internet',
        () async {
      // arrange
      when(() => mockRemoteDataSource.getPopularTVShows())
          .thenThrow(const SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getPopularTVShows();
      // assert
      expect(result,
          const Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Top Rated TV Shows', () {
    test('should return tv shows list when call to data source is successful',
        () async {
      // arrange
      when(() => mockRemoteDataSource.getTopRatedTVShows())
          .thenAnswer((_) async => tTVModelList);
      // act
      final result = await repository.getTopRatedTVShows();
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(() => mockRemoteDataSource.getTopRatedTVShows())
          .thenThrow(ServerException());
      // act
      final result = await repository.getTopRatedTVShows();
      // assert
      expect(result, const Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(() => mockRemoteDataSource.getTopRatedTVShows())
          .thenThrow(const SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTopRatedTVShows();
      // assert
      expect(result,
          const Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Get TV Detail', () {
    const tId = 1;
    const tTVDetailResponse = TvDetailResponse(
      adult: false,
      backdropPath: 'backdropPath',
      createdBy: [],
      episodeRunTime: [2],
      firstAirDate: null,
      genres: [GenreModel(id: 1, name: 'name')],
      homepage: 'homepage',
      id: 1,
      inProduction: false,
      languages: ['us'],
      lastAirDate: null,
      lastEpisodeToAir: LastEpisodeToAirModel(
        airDate: null,
        episodeNumber: 2,
        id: 2,
        name: 'name',
        overview: 'overview',
        productionCode: '12',
        runtime: 2,
        seasonNumber: 1,
        showId: 1,
        stillPath: 'stillPath',
        voteAverage: 2.2,
        voteCount: 11,
      ),
      name: 'name',
      nextEpisodeToAir: 'nextEpisodeToAir',
      networks: [
        NetworkModel(
            id: 1,
            name: 'name',
            logoPath: 'logoPath',
            originCountry: 'originCountry')
      ],
      numberOfEpisodes: 1,
      numberOfSeasons: 2,
      originCountry: ['originCountry'],
      originalLanguage: 'originalLanguage',
      originalName: 'originalName',
      overview: 'overview',
      popularity: 2.2,
      posterPath: 'posterPath',
      productionCompanies: ['productionCompanies'],
      productionCountries: ['productionCountries'],
      seasons: [
        SeasonModel(
          airDate: null,
          episodeCount: 1,
          id: 2,
          name: 'name',
          overview: 'overview',
          posterPath: 'posterPath',
          seasonNumber: 2,
        )
      ],
      spokenLanguages: [
        SpokenLanguageModel(
            englishName: 'englishName', iso6391: 'iso6391', name: 'name')
      ],
      status: 'status',
      tagline: 'tagline',
      type: 'type',
      voteAverage: 2.1,
      voteCount: 22,
    );

    test(
        'should return TV Show data when the call to remote data source is successful',
        () async {
      // arrange
      when(() => mockRemoteDataSource.getTVShowDetail(tId))
          .thenAnswer((_) async => tTVDetailResponse);
      // act
      final result = await repository.getTVShowDetail(tId);
      // assert
      verify(() => mockRemoteDataSource.getTVShowDetail(tId));
      expect(result, equals(const Right(testTVDetail)));
    });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(() => mockRemoteDataSource.getTVShowDetail(tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getTVShowDetail(tId);
      // assert
      verify(() => mockRemoteDataSource.getTVShowDetail(tId));
      expect(result, equals(const Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(() => mockRemoteDataSource.getTVShowDetail(tId))
          .thenThrow(const SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTVShowDetail(tId);
      // assert
      verify(() => mockRemoteDataSource.getTVShowDetail(tId));
      expect(
          result,
          equals(const Left(
              ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Get TV Season Detail', () {
    const tId = 1;
    const tSeasonNumber = 1;
    const tTVSeasonDetail = SeasonDetailResponse(
      id: '1',
      airDate: 'airDate',
      episodes: [
        EpisodeModel(
          airDate: 'airDate',
          episodeNumber: 2,
          id: 1,
          name: 'name',
          overview: 'overview',
          productionCode: '1',
          runtime: 3,
          seasonNumber: 1,
          showId: 2,
          stillPath: 'stillPath',
          voteAverage: 2.1,
          voteCount: 22,
          crew: [],
          guestStars: [],
        )
      ],
      name: 'name',
      overview: 'overview',
      seasonDetailResponseId: 2,
      posterPath: 'posterPath',
      seasonNumber: 2,
    );

    test(
        'should return TV Season Detail data when the call to remote data source is successful',
        () async {
      // arrange
      when(() => mockRemoteDataSource.getSeasonDetail(tId, tSeasonNumber))
          .thenAnswer((_) async => tTVSeasonDetail);
      // act
      final result = await repository.getSeasonDetail(tId, tSeasonNumber);
      // assert
      verify(() => mockRemoteDataSource.getSeasonDetail(tId, tSeasonNumber));
      expect(result, equals(const Right(testSeasonDetail)));
    });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(() => mockRemoteDataSource.getSeasonDetail(tId, tSeasonNumber))
          .thenThrow(ServerException());
      // act
      final result = await repository.getSeasonDetail(tId, tSeasonNumber);
      // assert
      verify(() => mockRemoteDataSource.getSeasonDetail(tId, tSeasonNumber));
      expect(result, equals(const Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(() => mockRemoteDataSource.getSeasonDetail(tId, tSeasonNumber))
          .thenThrow(const SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getSeasonDetail(tId, tSeasonNumber);
      // assert
      verify(() => mockRemoteDataSource.getSeasonDetail(tId, tSeasonNumber));
      expect(
          result,
          equals(const Left(
              ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Get TV Shows Recommendations', () {
    final tModelList = <TVModel>[];
    const tId = 1;

    test('should return data (tv show list) when the call is successful',
        () async {
      // arrange
      when(() => mockRemoteDataSource.getTVShowRecommendations(tId))
          .thenAnswer((_) async => tModelList);
      // act
      final result = await repository.getTVShowRecommendations(tId);
      // assert
      verify(() => mockRemoteDataSource.getTVShowRecommendations(tId));
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tModelList));
    });

    test(
        'should return server failure when call to remote data source is unsuccessful',
        () async {
      // arrange
      when(() => mockRemoteDataSource.getTVShowRecommendations(tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getTVShowRecommendations(tId);
      // assertbuild runner
      verify(() => mockRemoteDataSource.getTVShowRecommendations(tId));
      expect(result, equals(const Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to the internet',
        () async {
      // arrange
      when(() => mockRemoteDataSource.getTVShowRecommendations(tId))
          .thenThrow(const SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTVShowRecommendations(tId);
      // assert
      verify(() => mockRemoteDataSource.getTVShowRecommendations(tId));
      expect(
          result,
          equals(const Left(
              ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Search TV Show', () {
    const tQuery = 'spiderman';

    test('should return tv show list when call to data source is successful',
        () async {
      // arrange
      when(() => mockRemoteDataSource.searchTVShows(tQuery))
          .thenAnswer((_) async => tTVModelList);
      // act
      final result = await repository.searchTVShows(tQuery);
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(() => mockRemoteDataSource.searchTVShows(tQuery))
          .thenThrow(ServerException());
      // act
      final result = await repository.searchTVShows(tQuery);
      // assert
      expect(result, const Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(() => mockRemoteDataSource.searchTVShows(tQuery))
          .thenThrow(const SocketException('Failed to connect to the network'));
      // act
      final result = await repository.searchTVShows(tQuery);
      // assert
      expect(result,
          const Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(() => mockLocalDataSource.insertWatchlist(testTVTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveWatchlistTV(testTVDetail);
      // assert
      expect(result, const Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(() => mockLocalDataSource.insertWatchlist(testTVTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveWatchlistTV(testTVDetail);
      // assert
      expect(result, const Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(() => mockLocalDataSource.removeWatchlist(testTVTable))
          .thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result = await repository.removeWatchlistTV(testTVDetail);
      // assert
      expect(result, const Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(() => mockLocalDataSource.removeWatchlist(testTVTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repository.removeWatchlistTV(testTVDetail);
      // assert
      expect(result, const Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      const tId = 1;
      when(() => mockLocalDataSource.getTVById(tId))
          .thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlistTV(tId);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist tv shows', () {
    test('should return list of TV Shows', () async {
      // arrange
      when(() => mockLocalDataSource.getWatchlistTVShows())
          .thenAnswer((_) async => [testTVTable]);
      // act
      final result = await repository.getWatchlistTVShows();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTVShow]);
    });
  });
}

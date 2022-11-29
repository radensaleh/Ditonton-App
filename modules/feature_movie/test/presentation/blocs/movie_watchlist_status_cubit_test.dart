import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:feature_movie/domain/usecases/get_watchlist_status.dart';
import 'package:feature_movie/domain/usecases/remove_watchlist.dart';
import 'package:feature_movie/domain/usecases/save_watchlist.dart';
import 'package:feature_movie/presentation/blocs/watchlist_status_movie_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/dummy_data/dummy_objects.dart';

class MockGetWatchListStatus extends Mock implements GetWatchListStatus {}

class MockSaveWatchlist extends Mock implements SaveWatchlist {}

class MockRemoveWatchlist extends Mock implements RemoveWatchlist {}

void main() {
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;
  late WatchlistStatusMovieCubit watchlistStatusMovieCubit;

  setUp(() {
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    watchlistStatusMovieCubit = WatchlistStatusMovieCubit(
      getWatchListStatus: mockGetWatchListStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  const tId = 1;

  group('Movie Bloc, Watchlist Status Movie:', () {
    blocTest<WatchlistStatusMovieCubit, WatchlistStatusMovieState>(
      'should get watchlist true',
      build: () {
        when(() => mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => true);
        return watchlistStatusMovieCubit;
      },
      act: (bloc) => bloc.loadWatchlistStatus(tId),
      expect: () => [
        const WatchlistStatusMovieState(isAddedWatchlist: true, message: ''),
      ],
    );
  });

  group('Movie Bloc, Save Watchlist Movie:', () {
    blocTest<WatchlistStatusMovieCubit, WatchlistStatusMovieState>(
      'should execute save watchlist when function called',
      build: () {
        when(() => mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        when(() => mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);
        return watchlistStatusMovieCubit;
      },
      act: (bloc) => bloc.addWatchlistMovie(testMovieDetail),
      expect: () => [
        const WatchlistStatusMovieState(
            isAddedWatchlist: true, message: 'Added to Watchlist'),
      ],
    );

    blocTest<WatchlistStatusMovieCubit, WatchlistStatusMovieState>(
      'should update watchlist message when add watchlist failed',
      build: () {
        when(() => mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
        when(() => mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return watchlistStatusMovieCubit;
      },
      act: (bloc) => bloc.addWatchlistMovie(testMovieDetail),
      expect: () => [
        const WatchlistStatusMovieState(
            isAddedWatchlist: false, message: 'Failed'),
      ],
    );
  });

  group('Movie Bloc, Remove Watchlist Movie:', () {
    blocTest<WatchlistStatusMovieCubit, WatchlistStatusMovieState>(
      'should execute remove watchlist when function called',
      build: () {
        when(() => mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => const Right('Removed'));
        when(() => mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);
        return watchlistStatusMovieCubit;
      },
      act: (bloc) => bloc.removeFromWatchlistMovie(testMovieDetail),
      expect: () => [
        const WatchlistStatusMovieState(
            isAddedWatchlist: true, message: 'Removed'),
      ],
    );

    blocTest<WatchlistStatusMovieCubit, WatchlistStatusMovieState>(
      'should update watchlist message when remove watchlist failed',
      build: () {
        when(() => mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
        when(() => mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return watchlistStatusMovieCubit;
      },
      act: (bloc) => bloc.removeFromWatchlistMovie(testMovieDetail),
      expect: () => [
        const WatchlistStatusMovieState(
            isAddedWatchlist: false, message: 'Failed'),
      ],
    );
  });
}

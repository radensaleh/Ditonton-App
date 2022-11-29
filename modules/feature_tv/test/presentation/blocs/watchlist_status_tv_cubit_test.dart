import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:feature_tv/domain/usecases/get_watchlist_tv_status.dart';
import 'package:feature_tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:feature_tv/domain/usecases/save_watchlist_tv.dart';
import 'package:feature_tv/presentation/blocs/watchlist_status_tv/watchlist_status_tv_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/dummy_data/dummy_objects.dart';

class MockGetWatchListStatusTV extends Mock implements GetWatchlistTVStatus {}

class MockSaveWatchlistTV extends Mock implements SaveWatchlistTV {}

class MockRemoveWatchlistTV extends Mock implements RemoveWatchlistTV {}

void main() {
  late MockGetWatchListStatusTV mockGetWatchListStatusTV;
  late MockSaveWatchlistTV mockSaveWatchlistTV;
  late MockRemoveWatchlistTV mockRemoveWatchlistTV;
  late WatchlistStatusTvCubit watchlistStatusTVCubit;

  setUp(() {
    mockGetWatchListStatusTV = MockGetWatchListStatusTV();
    mockSaveWatchlistTV = MockSaveWatchlistTV();
    mockRemoveWatchlistTV = MockRemoveWatchlistTV();
    watchlistStatusTVCubit = WatchlistStatusTvCubit(
      getWatchlistTVStatus: mockGetWatchListStatusTV,
      saveWatchlistTV: mockSaveWatchlistTV,
      removeWatchlistTV: mockRemoveWatchlistTV,
    );
  });

  const tId = 1;

  group('TV Bloc, Get Watchlist Status TV:', () {
    blocTest<WatchlistStatusTvCubit, WatchlistStatusTvState>(
      'should get watchlist true',
      build: () {
        when(() => mockGetWatchListStatusTV.execute(tId))
            .thenAnswer((_) async => true);
        return watchlistStatusTVCubit;
      },
      act: (bloc) => bloc.loadWatchlistStatus(tId),
      expect: () => [
        const WatchlistStatusTvState(isAddedWatchlist: true, message: ''),
      ],
    );
  });

  group('TV Bloc, Save Watchlist TV:', () {
    blocTest<WatchlistStatusTvCubit, WatchlistStatusTvState>(
      'should execute save watchlist when function called',
      build: () {
        when(() => mockSaveWatchlistTV.execute(testTVDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        when(() => mockGetWatchListStatusTV.execute(testTVDetail.id))
            .thenAnswer((_) async => true);
        return watchlistStatusTVCubit;
      },
      act: (bloc) => bloc.addWatchlistTV(testTVDetail),
      expect: () => [
        const WatchlistStatusTvState(
            isAddedWatchlist: true, message: 'Added to Watchlist'),
      ],
    );

    blocTest<WatchlistStatusTvCubit, WatchlistStatusTvState>(
      'should update watchlist message when add watchlist failed',
      build: () {
        when(() => mockSaveWatchlistTV.execute(testTVDetail))
            .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
        when(() => mockGetWatchListStatusTV.execute(testTVDetail.id))
            .thenAnswer((_) async => false);
        return watchlistStatusTVCubit;
      },
      act: (bloc) => bloc.addWatchlistTV(testTVDetail),
      expect: () => [
        const WatchlistStatusTvState(
            isAddedWatchlist: false, message: 'Failed'),
      ],
    );
  });

  group('TV Bloc, Remove Watchlist TV:', () {
    blocTest<WatchlistStatusTvCubit, WatchlistStatusTvState>(
      'should execute remove watchlist when function called',
      build: () {
        when(() => mockRemoveWatchlistTV.execute(testTVDetail))
            .thenAnswer((_) async => const Right('Removed'));
        when(() => mockGetWatchListStatusTV.execute(testTVDetail.id))
            .thenAnswer((_) async => true);
        return watchlistStatusTVCubit;
      },
      act: (bloc) => bloc.removeFromWatchlistTV(testTVDetail),
      expect: () => [
        const WatchlistStatusTvState(
            isAddedWatchlist: true, message: 'Removed'),
      ],
    );

    blocTest<WatchlistStatusTvCubit, WatchlistStatusTvState>(
      'should update watchlist message when remove watchlist failed',
      build: () {
        when(() => mockRemoveWatchlistTV.execute(testTVDetail))
            .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
        when(() => mockGetWatchListStatusTV.execute(testTVDetail.id))
            .thenAnswer((_) async => false);
        return watchlistStatusTVCubit;
      },
      act: (bloc) => bloc.removeFromWatchlistTV(testTVDetail),
      expect: () => [
        const WatchlistStatusTvState(
            isAddedWatchlist: false, message: 'Failed'),
      ],
    );
  });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:feature_movie/domain/usecases/get_watchlist_movies.dart';
import 'package:feature_movie/presentation/blocs/watchlist_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/dummy_data/dummy_objects.dart';

class MockGetWatchlistMovies extends Mock implements GetWatchlistMovies {}

void main() {
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late WatchlistMovieBloc watchlistMovieBloc;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    watchlistMovieBloc =
        WatchlistMovieBloc(getWatchlistMovies: mockGetWatchlistMovies);
  });

  group('Movie Bloc, Watchlist Movie:', () {
    test('initialState should be Empty', () {
      expect(watchlistMovieBloc.state, WatchlistMovieEmptyState());
    });

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'should emit[Loading, HasData] when data is gotten successfully',
      build: () {
        when(() => mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Right([testWatchlistMovie]));
        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(FetchNowWatchlistMovie()),
      expect: () => [
        WatchlistMovieLoadingState(),
        WatchlistMovieHasDataState(result: [testWatchlistMovie])
      ],
      verify: (bloc) => verify(() => mockGetWatchlistMovies.execute()),
    );

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(() => mockGetWatchlistMovies.execute()).thenAnswer(
            (_) async => const Left(DatabaseFailure("Can't get data")));
        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(FetchNowWatchlistMovie()),
      expect: () => [
        WatchlistMovieLoadingState(),
        const WatchlistMovieErrorState(message: "Can't get data"),
      ],
      verify: (bloc) => verify(() => mockGetWatchlistMovies.execute()),
    );
  });
}

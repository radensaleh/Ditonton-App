import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:feature_movie/domain/entities/movie.dart';
import 'package:feature_movie/domain/usecases/get_now_playing_movies.dart';
import 'package:feature_movie/presentation/blocs/now_playing_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetNowPlayingMovies extends Mock implements GetNowPlayingMovies {}

void main() {
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late NowPlayingMovieBloc nowPlayingMovieBloc;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    nowPlayingMovieBloc =
        NowPlayingMovieBloc(getNowPlayingMovies: mockGetNowPlayingMovies);
  });

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovieList = <Movie>[tMovie];

  group('Movie Bloc, Now Playing Movie:', () {
    test('initialState should be Empty', () {
      expect(nowPlayingMovieBloc.state, NowPlayingMovieEmptyState());
    });

    blocTest<NowPlayingMovieBloc, NowPlayingMovieState>(
      'should emit[Loading, HasData] when data is gotten successfully',
      build: () {
        when(() => mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return nowPlayingMovieBloc;
      },
      act: (bloc) => bloc.add(FetchNowNowPlayingMovies()),
      expect: () => [
        NowPlayingMovieLoadingState(),
        NowPlayingMovieHasDataState(result: tMovieList)
      ],
      verify: (bloc) => verify(() => mockGetNowPlayingMovies.execute()),
    );

    blocTest<NowPlayingMovieBloc, NowPlayingMovieState>(
      'should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(() => mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return nowPlayingMovieBloc;
      },
      act: (bloc) => bloc.add(FetchNowNowPlayingMovies()),
      expect: () => [
        NowPlayingMovieLoadingState(),
        const NowPlayingMovieErrorState(message: 'Server Failure'),
      ],
      verify: (bloc) => verify(() => mockGetNowPlayingMovies.execute()),
    );
  });
}

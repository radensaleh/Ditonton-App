import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:feature_movie/domain/entities/movie.dart';
import 'package:feature_movie/domain/usecases/get_movie_recommendations.dart';
import 'package:feature_movie/presentation/blocs/recommendation_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetMovieRecommendations extends Mock
    implements GetMovieRecommendations {}

void main() {
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late RecommendationMovieBloc recommendationMovieBloc;

  setUp(() {
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    recommendationMovieBloc = RecommendationMovieBloc(
        getMovieRecommendations: mockGetMovieRecommendations);
  });

  const tId = 1;
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
  final tMovies = <Movie>[tMovie];

  group('Movie Bloc, Recommendation Movie', () {
    test('initialState should be Empty', () {
      expect(recommendationMovieBloc.state, RecommendationMovieEmptyState());
    });

    blocTest<RecommendationMovieBloc, RecommendationMovieState>(
      'Should emit[Loading, HasData] when data is gotten successfully',
      build: () {
        when(() => mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tMovies));
        return recommendationMovieBloc;
      },
      act: (bloc) => bloc.add(const FetchNowRecommendationMovie(id: tId)),
      expect: () => [
        RecommendationMovieLoadingState(),
        RecommendationMovieHasDataState(result: tMovies)
      ],
      verify: (bloc) => verify(() => mockGetMovieRecommendations.execute(tId)),
    );

    blocTest<RecommendationMovieBloc, RecommendationMovieState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(() => mockGetMovieRecommendations.execute(tId)).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return recommendationMovieBloc;
      },
      act: (bloc) => bloc.add(const FetchNowRecommendationMovie(id: tId)),
      expect: () => [
        RecommendationMovieLoadingState(),
        const RecommendationMovieErrorState(message: 'Server Failure'),
      ],
      verify: (bloc) => verify(() => mockGetMovieRecommendations.execute(tId)),
    );
  });
}

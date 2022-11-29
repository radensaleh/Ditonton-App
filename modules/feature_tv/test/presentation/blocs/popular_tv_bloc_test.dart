import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:feature_tv/domain/entities/tv.dart';
import 'package:feature_tv/domain/usecases/get_popular_tv_shows.dart';
import 'package:feature_tv/presentation/blocs/popular_tv/popular_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetPopularTVShows extends Mock implements GetPopularTVShows {}

void main() {
  late MockGetPopularTVShows mockGetPopularTVShows;
  late PopularTvBloc popularTVBloc;

  setUp(() {
    mockGetPopularTVShows = MockGetPopularTVShows();
    popularTVBloc = PopularTvBloc(getPopularTVShows: mockGetPopularTVShows);
  });

  final tTVShow = TV(
    backdropPath: 'backdropPath',
    firstAirDate: DateTime.parse("2021-05-23"),
    genreIds: const [1, 2, 3],
    id: 1,
    name: 'name',
    originCountry: const ['en'],
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1.0,
    posterPath: 'posterPath',
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tTVShowsList = <TV>[tTVShow];

  group('TV Bloc, Popular TV Shows:', () {
    test('initialState should be Empty', () {
      expect(popularTVBloc.state, PopularTvInitialState());
    });

    blocTest<PopularTvBloc, PopularTvState>(
      'should emit[Loading, HasData] when data is gotten successfully',
      build: () {
        when(() => mockGetPopularTVShows.execute())
            .thenAnswer((_) async => Right(tTVShowsList));
        return popularTVBloc;
      },
      act: (bloc) => bloc.add(FetchPopularTvShows()),
      expect: () => [
        PopularTvLoadingState(),
        PopularTvHasDataState(result: tTVShowsList)
      ],
      verify: (bloc) => verify(() => mockGetPopularTVShows.execute()),
    );

    blocTest<PopularTvBloc, PopularTvState>(
      'should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(() => mockGetPopularTVShows.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return popularTVBloc;
      },
      act: (bloc) => bloc.add(FetchPopularTvShows()),
      expect: () => [
        PopularTvLoadingState(),
        const PopularTvErrorState(message: 'Server Failure'),
      ],
      verify: (bloc) => verify(() => mockGetPopularTVShows.execute()),
    );
  });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:feature_tv/domain/entities/tv.dart';
import 'package:feature_tv/domain/usecases/get_on_the_air_tv_shows.dart';
import 'package:feature_tv/presentation/blocs/on_the_air_tv/on_the_air_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetOnTheAirTVShows extends Mock implements GetOnTheAirTVShows {}

void main() {
  late MockGetOnTheAirTVShows mockGetOnTheAirTVShows;
  late OnTheAirTvBloc onTheAirTVBloc;

  setUp(() {
    mockGetOnTheAirTVShows = MockGetOnTheAirTVShows();
    onTheAirTVBloc = OnTheAirTvBloc(getOnTheAirTVShows: mockGetOnTheAirTVShows);
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

  group('TV Bloc, On The Air TV Shows:', () {
    test('initialState should be Empty', () {
      expect(onTheAirTVBloc.state, OnTheAirTvInitialState());
    });

    blocTest<OnTheAirTvBloc, OnTheAirTvState>(
      'should emit[Loading, HasData] when data is gotten successfully',
      build: () {
        when(() => mockGetOnTheAirTVShows.execute())
            .thenAnswer((_) async => Right(tTVShowsList));
        return onTheAirTVBloc;
      },
      act: (bloc) => bloc.add(FetchOnTheAirTvShows()),
      expect: () => [
        OnTheAirTvLoadingState(),
        OnTheAirTvHasDataState(result: tTVShowsList)
      ],
      verify: (bloc) => verify(() => mockGetOnTheAirTVShows.execute()),
    );

    blocTest<OnTheAirTvBloc, OnTheAirTvState>(
      'should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(() => mockGetOnTheAirTVShows.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return onTheAirTVBloc;
      },
      act: (bloc) => bloc.add(FetchOnTheAirTvShows()),
      expect: () => [
        OnTheAirTvLoadingState(),
        const OnTheAirTvErrorState(message: 'Server Failure'),
      ],
      verify: (bloc) => verify(() => mockGetOnTheAirTVShows.execute()),
    );
  });
}

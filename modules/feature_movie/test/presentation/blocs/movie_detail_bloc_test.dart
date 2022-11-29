import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:feature_movie/domain/usecases/get_movie_detail.dart';
import 'package:feature_movie/presentation/blocs/detail_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/dummy_data/dummy_objects.dart';

class MockGetMovieDetail extends Mock implements GetMovieDetail {}

void main() {
  late MockGetMovieDetail mockGetMovieDetail;
  late DetailMovieBloc detailMovieBloc;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    detailMovieBloc = DetailMovieBloc(getMovieDetail: mockGetMovieDetail);
  });

  const tId = 1;

  group('Movie Bloc, Movie Detail:', () {
    test('initialState should be Empty', () {
      expect(detailMovieBloc.state, DetailMovieEmptyState());
    });

    blocTest<DetailMovieBloc, DetailMovieState>(
      'should emit[Loading, HasData] when data is gotten successfully',
      build: () {
        when(() => mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => const Right(testMovieDetail));
        return detailMovieBloc;
      },
      act: (bloc) => bloc.add(const FetchNowDetailMovie(id: tId)),
      expect: () => [
        DetailMovieLoadingState(),
        const DetailMovieHasDataState(result: testMovieDetail)
      ],
      verify: (bloc) => verify(() => mockGetMovieDetail.execute(tId)),
    );

    blocTest<DetailMovieBloc, DetailMovieState>(
      'should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(() => mockGetMovieDetail.execute(tId)).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return detailMovieBloc;
      },
      act: (bloc) => bloc.add(const FetchNowDetailMovie(id: tId)),
      expect: () => [
        DetailMovieLoadingState(),
        const DetailMovieErrorState(message: 'Server Failure'),
      ],
      verify: (bloc) => verify(() => mockGetMovieDetail.execute(tId)),
    );
  });
}

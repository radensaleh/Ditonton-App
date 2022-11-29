import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:feature_tv/domain/usecases/get_tv_show_detail.dart';
import 'package:feature_tv/presentation/blocs/detail_tv/detail_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/dummy_data/dummy_objects.dart';

class MockGetTVShowDetail extends Mock implements GetTVShowDetail {}

void main() {
  late MockGetTVShowDetail mockGetTVShowDetail;
  late DetailTvBloc detailTVBloc;

  setUp(() {
    mockGetTVShowDetail = MockGetTVShowDetail();
    detailTVBloc = DetailTvBloc(getTVShowDetail: mockGetTVShowDetail);
  });

  const tId = 1;

  group('TV Bloc, Get TV Show Detail:', () {
    test('initialState should be Empty', () {
      expect(detailTVBloc.state, DetailTvInitialState());
    });

    blocTest<DetailTvBloc, DetailTvState>(
      'should emit[Loading, HasData] when data is gotten successfully',
      build: () {
        when(() => mockGetTVShowDetail.execute(tId))
            .thenAnswer((_) async => const Right(testTVDetail));
        return detailTVBloc;
      },
      act: (bloc) => bloc.add(const FetchDetailTvShow(id: tId)),
      expect: () => [
        DetailTvLoadingState(),
        const DetailTvHasDataState(result: testTVDetail)
      ],
      verify: (bloc) => verify(() => mockGetTVShowDetail.execute(tId)),
    );

    blocTest<DetailTvBloc, DetailTvState>(
      'should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(() => mockGetTVShowDetail.execute(tId)).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return detailTVBloc;
      },
      act: (bloc) => bloc.add(const FetchDetailTvShow(id: tId)),
      expect: () => [
        DetailTvLoadingState(),
        const DetailTvErrorState(message: 'Server Failure'),
      ],
      verify: (bloc) => verify(() => mockGetTVShowDetail.execute(tId)),
    );
  });
}

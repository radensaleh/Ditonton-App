import 'package:bloc_test/bloc_test.dart';
import 'package:feature_tv/presentation/blocs/detail_tv/detail_tv_bloc.dart';
import 'package:feature_tv/presentation/blocs/recommendation_tv/recommendation_tv_bloc.dart';
import 'package:feature_tv/presentation/blocs/watchlist_status_tv/watchlist_status_tv_cubit.dart';
import 'package:feature_tv/presentation/pages/tv_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/dummy_data/dummy_objects.dart';

class MockDetailTvBloc extends MockBloc<DetailTvEvent, DetailTvState>
    implements DetailTvBloc {}

class DetailTvEventFake extends Fake implements DetailTvEvent {}

class DetailTvStateFake extends Fake implements DetailTvState {}

class MockRecommendationTvBloc
    extends MockBloc<RecommendationTvEvent, RecommendationTvState>
    implements RecommendationTvBloc {}

class RecommendationTvEventFake extends Fake implements RecommendationTvEvent {}

class RecommendationTvStateFake extends Fake implements RecommendationTvState {}

class MockWatchlistStatusTvCubit extends MockCubit<WatchlistStatusTvState>
    implements WatchlistStatusTvCubit {}

class WatchlistStatusTvStateFake extends Fake
    implements WatchlistStatusTvState {}

void main() {
  late MockDetailTvBloc mockDetailTvBloc;
  late MockRecommendationTvBloc mockRecommendationTvBloc;
  late MockWatchlistStatusTvCubit mockWatchlistStatusTvCubit;

  setUpAll(() {
    registerFallbackValue(DetailTvEventFake());
    registerFallbackValue(DetailTvStateFake());
  });

  setUp(() {
    mockDetailTvBloc = MockDetailTvBloc();
    mockRecommendationTvBloc = MockRecommendationTvBloc();
    mockWatchlistStatusTvCubit = MockWatchlistStatusTvCubit();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DetailTvBloc>.value(value: mockDetailTvBloc),
        BlocProvider<RecommendationTvBloc>.value(
            value: mockRecommendationTvBloc),
        BlocProvider<WatchlistStatusTvCubit>.value(
          value: mockWatchlistStatusTvCubit,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('TV Page, Detail TV Page:', () {
    testWidgets('page should nothing when empty', (WidgetTester tester) async {
      when(() => mockDetailTvBloc.state).thenReturn(DetailTvInitialState());
      when(() => mockWatchlistStatusTvCubit.state).thenReturn(
          const WatchlistStatusTvState(isAddedWatchlist: false, message: ''));
      when(() => mockRecommendationTvBloc.state)
          .thenReturn(RecommendationTvInitialState());

      await tester
          .pumpWidget(makeTestableWidget(TVDetailPage(id: testTVDetail.id)));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      expect(progressBarFinder, findsNothing);
    });

    testWidgets('page should display center progress bar when loading',
        (WidgetTester tester) async {
      when(() => mockDetailTvBloc.state).thenReturn(DetailTvLoadingState());
      when(() => mockWatchlistStatusTvCubit.state).thenReturn(
          const WatchlistStatusTvState(isAddedWatchlist: false, message: ''));
      when(() => mockRecommendationTvBloc.state)
          .thenReturn(RecommendationTvLoadingState());

      await tester
          .pumpWidget(makeTestableWidget(TVDetailPage(id: testTVDetail.id)));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('page should display Detail when data is loaded',
        (WidgetTester tester) async {
      when(() => mockDetailTvBloc.state)
          .thenReturn(const DetailTvHasDataState(result: testTVDetail));
      when(() => mockWatchlistStatusTvCubit.state).thenReturn(
          const WatchlistStatusTvState(isAddedWatchlist: false, message: ''));
      when(() => mockRecommendationTvBloc.state)
          .thenReturn(RecommendationTvHasDataState(result: testTVShowsList));

      await tester.pumpWidget(makeTestableWidget(TVDetailPage(
        id: testTVDetail.id,
      )));

      final buttonFinder = find.byType(ElevatedButton);

      expect(buttonFinder, findsOneWidget);
    });

    testWidgets('page should display text with message when Error',
        (WidgetTester tester) async {
      when(() => mockDetailTvBloc.state)
          .thenReturn(const DetailTvErrorState(message: 'Error'));
      when(() => mockWatchlistStatusTvCubit.state).thenReturn(
          const WatchlistStatusTvState(isAddedWatchlist: false, message: ''));
      when(() => mockRecommendationTvBloc.state)
          .thenReturn(const RecommendationTvErrorState(message: 'Error'));

      await tester.pumpWidget(makeTestableWidget(TVDetailPage(
        id: testTVDetail.id,
      )));

      final textFinder = find.byKey(const Key('error_message'));
      expect(textFinder, findsOneWidget);
    });
  });

  group('TV Page, Detail TV Widgets:', () {
    testWidgets(
        'watchlist button should display add icon when movie not added to watchlist',
        (tester) async {
      final watchlistButton = find.byType(ElevatedButton);
      final iconButton = find.byIcon(Icons.add);

      when(() => mockDetailTvBloc.state)
          .thenReturn(const DetailTvHasDataState(result: testTVDetail));
      when(() => mockWatchlistStatusTvCubit.state).thenReturn(
          const WatchlistStatusTvState(isAddedWatchlist: false, message: ''));
      when(() => mockRecommendationTvBloc.state)
          .thenReturn(RecommendationTvHasDataState(result: testTVShowsList));

      await tester
          .pumpWidget(makeTestableWidget(TVDetailPage(id: testTVDetail.id)));

      expect(watchlistButton, findsOneWidget);
      expect(iconButton, findsOneWidget);
    });

    testWidgets(
        'watchlist button should dispay check icon when movie is added to wathclist',
        (tester) async {
      final watchlistButton = find.byType(ElevatedButton);
      final iconButton = find.byIcon(Icons.check);

      when(() => mockDetailTvBloc.state)
          .thenReturn(const DetailTvHasDataState(result: testTVDetail));
      when(() => mockWatchlistStatusTvCubit.state).thenReturn(
          const WatchlistStatusTvState(isAddedWatchlist: true, message: ''));
      when(() => mockRecommendationTvBloc.state)
          .thenReturn(RecommendationTvHasDataState(result: testTVShowsList));

      await tester
          .pumpWidget(makeTestableWidget(TVDetailPage(id: testTVDetail.id)));

      expect(watchlistButton, findsOneWidget);
      expect(iconButton, findsOneWidget);
    });
  });
}

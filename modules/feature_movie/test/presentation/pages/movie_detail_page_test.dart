import 'package:bloc_test/bloc_test.dart';
import 'package:feature_movie/presentation/blocs/detail_movie_bloc.dart';
import 'package:feature_movie/presentation/blocs/recommendation_movie_bloc.dart';
import 'package:feature_movie/presentation/blocs/watchlist_status_movie_cubit.dart';
import 'package:feature_movie/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/dummy_data/dummy_objects.dart';

class MockDetailMovieBloc extends MockBloc<DetailMovieEvent, DetailMovieState>
    implements DetailMovieBloc {}

class DetailMovieEventFake extends Fake implements DetailMovieEvent {}

class DetailMovieStateFake extends Fake implements DetailMovieState {}

class MockRecommendationMovieBloc
    extends MockBloc<RecommendationMovieEvent, RecommendationMovieState>
    implements RecommendationMovieBloc {}

class RecommendationMovieEventFake extends Fake
    implements RecommendationMovieEvent {}

class RecommendationMovieStateFake extends Fake
    implements RecommendationMovieState {}

class MockWatchlistStatusMovieCubit extends MockCubit<WatchlistStatusMovieState>
    implements WatchlistStatusMovieCubit {}

class WatchlistStatusMovieStateFake extends Fake
    implements WatchlistStatusMovieState {}

void main() {
  late MockDetailMovieBloc mockDetailMovieBloc;
  late MockRecommendationMovieBloc mockRecommendationMovieBloc;
  late MockWatchlistStatusMovieCubit mockWatchlistStatusMovieCubit;

  setUpAll(() {
    registerFallbackValue(DetailMovieEventFake());
    registerFallbackValue(DetailMovieStateFake());
  });

  setUp(() {
    mockDetailMovieBloc = MockDetailMovieBloc();
    mockRecommendationMovieBloc = MockRecommendationMovieBloc();
    mockWatchlistStatusMovieCubit = MockWatchlistStatusMovieCubit();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DetailMovieBloc>.value(value: mockDetailMovieBloc),
        BlocProvider<RecommendationMovieBloc>.value(
            value: mockRecommendationMovieBloc),
        BlocProvider<WatchlistStatusMovieCubit>.value(
          value: mockWatchlistStatusMovieCubit,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('Movie Page, Detail Movie Page:', () {
    testWidgets('page should nothing when empty', (WidgetTester tester) async {
      when(() => mockDetailMovieBloc.state).thenReturn(DetailMovieEmptyState());
      when(() => mockWatchlistStatusMovieCubit.state).thenReturn(
          const WatchlistStatusMovieState(
              isAddedWatchlist: false, message: ''));
      when(() => mockRecommendationMovieBloc.state)
          .thenReturn(RecommendationMovieEmptyState());

      await tester.pumpWidget(
          makeTestableWidget(MovieDetailPage(id: testMovieDetail.id)));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      expect(progressBarFinder, findsNothing);
    });

    testWidgets('page should display center progress bar when loading',
        (WidgetTester tester) async {
      when(() => mockDetailMovieBloc.state)
          .thenReturn(DetailMovieLoadingState());
      when(() => mockWatchlistStatusMovieCubit.state).thenReturn(
          const WatchlistStatusMovieState(
              isAddedWatchlist: false, message: ''));
      when(() => mockRecommendationMovieBloc.state)
          .thenReturn(RecommendationMovieLoadingState());

      await tester.pumpWidget(
          makeTestableWidget(MovieDetailPage(id: testMovieDetail.id)));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('page should display Detail when data is loaded',
        (WidgetTester tester) async {
      when(() => mockDetailMovieBloc.state)
          .thenReturn(const DetailMovieHasDataState(result: testMovieDetail));
      when(() => mockWatchlistStatusMovieCubit.state).thenReturn(
          const WatchlistStatusMovieState(
              isAddedWatchlist: false, message: ''));
      when(() => mockRecommendationMovieBloc.state)
          .thenReturn(RecommendationMovieHasDataState(result: testMovieList));

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(
        id: testMovieDetail.id,
      )));

      final buttonFinder = find.byType(ElevatedButton);
      final listViewFinder = find.byType(ListView);

      expect(buttonFinder, findsOneWidget);
      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('page should display text with message when Error',
        (WidgetTester tester) async {
      when(() => mockDetailMovieBloc.state)
          .thenReturn(const DetailMovieErrorState(message: 'Error'));
      when(() => mockWatchlistStatusMovieCubit.state).thenReturn(
          const WatchlistStatusMovieState(
              isAddedWatchlist: false, message: ''));
      when(() => mockRecommendationMovieBloc.state)
          .thenReturn(const RecommendationMovieErrorState(message: 'Error'));

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(
        id: testMovieDetail.id,
      )));

      final textFinder = find.byKey(const Key('error_message'));
      expect(textFinder, findsOneWidget);
    });
  });

  group('Movie Page, Detail Movie Widgets:', () {
    testWidgets(
        'watchlist button should display add icon when movie not added to watchlist',
        (tester) async {
      final watchlistButton = find.byType(ElevatedButton);
      final iconButton = find.byIcon(Icons.add);

      when(() => mockDetailMovieBloc.state)
          .thenReturn(const DetailMovieHasDataState(result: testMovieDetail));
      when(() => mockWatchlistStatusMovieCubit.state).thenReturn(
          const WatchlistStatusMovieState(
              isAddedWatchlist: false, message: ''));
      when(() => mockRecommendationMovieBloc.state)
          .thenReturn(RecommendationMovieHasDataState(result: testMovieList));

      await tester.pumpWidget(
          makeTestableWidget(MovieDetailPage(id: testMovieDetail.id)));

      expect(watchlistButton, findsOneWidget);
      expect(iconButton, findsOneWidget);
    });

    testWidgets(
        'watchlist button should dispay check icon when movie is added to wathclist',
        (tester) async {
      final watchlistButton = find.byType(ElevatedButton);
      final iconButton = find.byIcon(Icons.check);

      when(() => mockDetailMovieBloc.state)
          .thenReturn(const DetailMovieHasDataState(result: testMovieDetail));
      when(() => mockWatchlistStatusMovieCubit.state).thenReturn(
          const WatchlistStatusMovieState(isAddedWatchlist: true, message: ''));
      when(() => mockRecommendationMovieBloc.state)
          .thenReturn(RecommendationMovieHasDataState(result: testMovieList));

      await tester.pumpWidget(
          makeTestableWidget(MovieDetailPage(id: testMovieDetail.id)));

      expect(watchlistButton, findsOneWidget);
      expect(iconButton, findsOneWidget);
    });
  });
}

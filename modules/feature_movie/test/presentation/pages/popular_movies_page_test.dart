import 'package:bloc_test/bloc_test.dart';
import 'package:feature_movie/presentation/blocs/popular_movie_bloc.dart';
import 'package:feature_movie/presentation/pages/popular_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/dummy_data/dummy_objects.dart';

class MockPopularMovieBloc
    extends MockBloc<PopularMovieEvent, PopularMovieState>
    implements PopularMovieBloc {}

class PopularMovieEventFake extends Fake implements PopularMovieEvent {}

class PopularMovieStateFake extends Fake implements PopularMovieState {}

void main() {
  late MockPopularMovieBloc mockPopularMovieBloc;

  setUpAll(() {
    registerFallbackValue(PopularMovieEventFake());
    registerFallbackValue(PopularMovieStateFake());
  });

  setUp(() {
    mockPopularMovieBloc = MockPopularMovieBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularMovieBloc>.value(
      value: mockPopularMovieBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('Movie Page, Popular Movie Page:', () {
    testWidgets('page should nothing when empty', (WidgetTester tester) async {
      when(() => mockPopularMovieBloc.state)
          .thenReturn(PopularMovieEmptyState());
      await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      expect(progressBarFinder, findsNothing);
    });

    testWidgets('page should display center progress bar when loading',
        (WidgetTester tester) async {
      when(() => mockPopularMovieBloc.state)
          .thenReturn(PopularMovieLoadingState());
      await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('page should display ListView when data is loaded',
        (WidgetTester tester) async {
      when(() => mockPopularMovieBloc.state)
          .thenReturn(PopularMovieHasDataState(result: testMovieList));

      await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

      final listViewFinder = find.byType(ListView);
      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('page should display text with message when Error',
        (WidgetTester tester) async {
      when(() => mockPopularMovieBloc.state)
          .thenReturn(const PopularMovieErrorState(message: 'Error'));

      await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

      final textFinder = find.byKey(const Key('error_message'));
      expect(textFinder, findsOneWidget);
    });
  });
}

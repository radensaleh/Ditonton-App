import 'package:bloc_test/bloc_test.dart';
import 'package:feature_movie/presentation/blocs/search_movie_bloc.dart';
import 'package:feature_movie/presentation/pages/search_movie_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/dummy_data/dummy_objects.dart';

class MockSearchMovieBloc extends MockBloc<SearchMovieEvent, SearchMovieState>
    implements SearchMovieBloc {}

class SearchMovieEventFake extends Fake implements SearchMovieEvent {}

class SearchMovieStateFake extends Fake implements SearchMovieState {}

void main() {
  late MockSearchMovieBloc mockSearchMovieBloc;

  setUpAll(() {
    registerFallbackValue(SearchMovieEventFake());
    registerFallbackValue(SearchMovieStateFake());
  });

  setUp(() {
    mockSearchMovieBloc = MockSearchMovieBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<SearchMovieBloc>.value(
      value: mockSearchMovieBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('Movie Page, Search Movie Page:', () {
    testWidgets('page should display center progress bar when loading',
        (WidgetTester tester) async {
      when(() => mockSearchMovieBloc.state)
          .thenReturn(SearchMovieLoadingState());
      await tester.pumpWidget(makeTestableWidget(const SearchMoviePage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('page should display ListView when data is loaded',
        (WidgetTester tester) async {
      when(() => mockSearchMovieBloc.state)
          .thenReturn(SearchMovieHasDataState(result: testMovieList));

      await tester.pumpWidget(makeTestableWidget(const SearchMoviePage()));

      final listViewFinder = find.byType(ListView);
      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('page should display text with message when Error',
        (WidgetTester tester) async {
      when(() => mockSearchMovieBloc.state)
          .thenReturn(const SearchMovieErrorState(message: 'Error'));

      await tester.pumpWidget(makeTestableWidget(const SearchMoviePage()));

      final textFinder = find.byKey(const Key('error_message'));
      expect(textFinder, findsOneWidget);
    });
  });
}

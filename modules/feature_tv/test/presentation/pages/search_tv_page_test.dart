import 'package:bloc_test/bloc_test.dart';
import 'package:feature_tv/presentation/blocs/search_tv/search_tv_bloc.dart';
import 'package:feature_tv/presentation/pages/search_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/dummy_data/dummy_objects.dart';

class MockSearchTvBloc extends MockBloc<SearchTvEvent, SearchTvState>
    implements SearchTvBloc {}

class SearchTvEventFake extends Fake implements SearchTvEvent {}

class SearchTvStateFake extends Fake implements SearchTvState {}

void main() {
  late MockSearchTvBloc mockSearchTvBloc;

  setUpAll(() {
    registerFallbackValue(SearchTvEventFake());
    registerFallbackValue(SearchTvStateFake());
  });

  setUp(() {
    mockSearchTvBloc = MockSearchTvBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<SearchTvBloc>.value(
      value: mockSearchTvBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('TV Page, Search TV Page:', () {
    testWidgets('page should display center progress bar when loading',
        (WidgetTester tester) async {
      when(() => mockSearchTvBloc.state).thenReturn(SearchTvLoadingState());
      await tester.pumpWidget(makeTestableWidget(const SearchTVPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('page should display ListView when data is loaded',
        (WidgetTester tester) async {
      when(() => mockSearchTvBloc.state)
          .thenReturn(SearchTvHasDataState(result: testTVShowsList));

      await tester.pumpWidget(makeTestableWidget(const SearchTVPage()));

      final listViewFinder = find.byType(ListView);
      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('page should display text with message when Error',
        (WidgetTester tester) async {
      when(() => mockSearchTvBloc.state)
          .thenReturn(const SearchTvErrorState(message: 'Error'));

      await tester.pumpWidget(makeTestableWidget(const SearchTVPage()));

      final textFinder = find.byKey(const Key('error_message'));
      expect(textFinder, findsOneWidget);
    });
  });
}

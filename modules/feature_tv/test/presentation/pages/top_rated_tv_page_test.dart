import 'package:bloc_test/bloc_test.dart';
import 'package:feature_tv/presentation/blocs/top_rated_tv/top_rated_tv_bloc.dart';
import 'package:feature_tv/presentation/pages/top_rated_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/dummy_data/dummy_objects.dart';

class MockTopRatedTvBloc extends MockBloc<TopRatedTvEvent, TopRatedTvState>
    implements TopRatedTvBloc {}

class TopRatedTvEventFake extends Fake implements TopRatedTvEvent {}

class TopRatedTvStateFake extends Fake implements TopRatedTvState {}

void main() {
  late MockTopRatedTvBloc mockTopRatedTvBloc;

  setUpAll(() {
    registerFallbackValue(TopRatedTvEventFake());
    registerFallbackValue(TopRatedTvStateFake());
  });

  setUp(() {
    mockTopRatedTvBloc = MockTopRatedTvBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTvBloc>.value(
      value: mockTopRatedTvBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('TV Page, Top Rated TV Page:', () {
    testWidgets('page should display center progress bar when loading',
        (WidgetTester tester) async {
      when(() => mockTopRatedTvBloc.state).thenReturn(TopRatedTvLoadingState());
      await tester.pumpWidget(makeTestableWidget(const TopRatedTVPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('page should display ListView when data is loaded',
        (WidgetTester tester) async {
      when(() => mockTopRatedTvBloc.state)
          .thenReturn(TopRatedTvHasDataState(result: testTVShowsList));

      await tester.pumpWidget(makeTestableWidget(const TopRatedTVPage()));

      final listViewFinder = find.byType(ListView);
      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('page should display text with message when Error',
        (WidgetTester tester) async {
      when(() => mockTopRatedTvBloc.state)
          .thenReturn(const TopRatedTvErrorState(message: 'Error'));

      await tester.pumpWidget(makeTestableWidget(const TopRatedTVPage()));

      final textFinder = find.byKey(const Key('error_message'));
      expect(textFinder, findsOneWidget);
    });
  });
}

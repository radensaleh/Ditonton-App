import 'package:bloc_test/bloc_test.dart';
import 'package:feature_tv/presentation/blocs/popular_tv/popular_tv_bloc.dart';
import 'package:feature_tv/presentation/pages/popular_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/dummy_data/dummy_objects.dart';

class MockPopularTvBloc extends MockBloc<PopularTvEvent, PopularTvState>
    implements PopularTvBloc {}

class PopularTvEventFake extends Fake implements PopularTvEvent {}

class PopularTvStateFake extends Fake implements PopularTvState {}

void main() {
  late MockPopularTvBloc mockPopularTvBloc;

  setUpAll(() {
    registerFallbackValue(PopularTvEventFake());
    registerFallbackValue(PopularTvStateFake());
  });

  setUp(() {
    mockPopularTvBloc = MockPopularTvBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularTvBloc>.value(
      value: mockPopularTvBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('TV Page, Popular TV Page:', () {
    testWidgets('page should display center progress bar when loading',
        (WidgetTester tester) async {
      when(() => mockPopularTvBloc.state).thenReturn(PopularTvLoadingState());
      await tester.pumpWidget(makeTestableWidget(const PopularTVPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('page should display ListView when data is loaded',
        (WidgetTester tester) async {
      when(() => mockPopularTvBloc.state)
          .thenReturn(PopularTvHasDataState(result: testTVShowsList));

      await tester.pumpWidget(makeTestableWidget(const PopularTVPage()));

      final listViewFinder = find.byType(ListView);
      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('page should display text with message when Error',
        (WidgetTester tester) async {
      when(() => mockPopularTvBloc.state)
          .thenReturn(const PopularTvErrorState(message: 'Error'));

      await tester.pumpWidget(makeTestableWidget(const PopularTVPage()));

      final textFinder = find.byKey(const Key('error_message'));
      expect(textFinder, findsOneWidget);
    });
  });
}

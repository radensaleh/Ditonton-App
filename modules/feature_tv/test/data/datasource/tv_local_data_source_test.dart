import 'package:core/core.dart';
import 'package:feature_tv/data/datasource/tv_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/dummy_data/dummy_objects.dart';

class MockDatabaseHelper extends Mock implements DatabaseHelper {}

void main() {
  late TVLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = TVLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group('save watchlist', () {
    test('should return success message when insert to database is success',
        () async {
      // arrange
      when(() => mockDatabaseHelper.insertWatchlistTV(testTVTable))
          .thenAnswer((_) async => 1);
      // act
      final result = await dataSource.insertWatchlist(testTVTable);
      // assert
      expect(result, 'Added TV to Watchlist');
    });

    test('should throw DatabaseException when insert to database is failed',
        () async {
      // arrange
      when(() => mockDatabaseHelper.insertWatchlistTV(testTVTable))
          .thenThrow(Exception());
      // act
      final call = dataSource.insertWatchlist(testTVTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove from database is success',
        () async {
      // arrange
      when(() => mockDatabaseHelper.removeWatchlistTV(testTVTable))
          .thenAnswer((_) async => 1);
      // act
      final result = await dataSource.removeWatchlist(testTVTable);
      // assert
      expect(result, 'Removed TV from Watchlist');
    });

    test('should throw DatabaseException when remove from database is failed',
        () async {
      // arrange
      when(() => mockDatabaseHelper.removeWatchlistTV(testTVTable))
          .thenThrow(Exception());
      // act
      final call = dataSource.removeWatchlist(testTVTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('Get TV Shows Detail By Id', () {
    const tId = 1;

    test('should return TV Shows Detail Table when data is found', () async {
      // arrange
      when(() => mockDatabaseHelper.getTVById(tId))
          .thenAnswer((_) async => testTVMap);
      // act
      final result = await dataSource.getTVById(tId);
      // assert
      expect(result, testTVTable);
    });

    test('should return null when data is not found', () async {
      // arrange
      when(() => mockDatabaseHelper.getTVById(tId))
          .thenAnswer((_) async => null);
      // act
      final result = await dataSource.getTVById(tId);
      // assert
      expect(result, null);
    });
  });

  group('get watchlist tv shows', () {
    test('should return list of TVTable from database', () async {
      // arrange
      when(() => mockDatabaseHelper.getWatchlistTVShows())
          .thenAnswer((_) async => [testTVMap]);
      // act
      final result = await dataSource.getWatchlistTVShows();
      // assert
      expect(result, [testTVTable]);
    });
  });
}

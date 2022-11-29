import 'package:dartz/dartz.dart';
import 'package:feature_tv/domain/entities/tv.dart';
import 'package:feature_tv/domain/repositories/tv_repository.dart';
import 'package:feature_tv/domain/usecases/search_tv_shows.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTVRepository extends Mock implements TVRepository {}

void main() {
  late SearchTVShows usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = SearchTVShows(repository: mockTVRepository);
  });

  final tTVShows = <TV>[];
  const tQuery = 'Spiderman';

  group('SearchTVShows Tests', () {
    test('should get list of tv shows from the repository', () async {
      // arrange
      when(() => mockTVRepository.searchTVShows(tQuery))
          .thenAnswer((_) async => Right(tTVShows));
      // act
      final result = await usecase.execute(tQuery);
      // assert
      expect(result, Right(tTVShows));
    });
  });
}

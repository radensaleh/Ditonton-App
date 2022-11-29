import 'package:dartz/dartz.dart';
import 'package:feature_tv/domain/repositories/tv_repository.dart';
import 'package:feature_tv/domain/usecases/save_watchlist_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/dummy_data/dummy_objects.dart';

class MockTVRepository extends Mock implements TVRepository {}

void main() {
  late SaveWatchlistTV usecase;
  late MockTVRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockTVRepository();
    usecase = SaveWatchlistTV(repository: mockMovieRepository);
  });

  group('SaveWatchlistTV Tests', () {
    test(
        'should add watchlist tv shows from repository when execute function is called',
        () async {
      // arrange
      when(() => mockMovieRepository.saveWatchlistTV(testTVDetail))
          .thenAnswer((_) async => const Right('Added TV from Watchlist'));
      // act
      final result = await usecase.execute(testTVDetail);
      // assert
      expect(result, const Right('Added TV from Watchlist'));
    });
  });
}

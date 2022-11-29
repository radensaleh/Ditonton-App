import 'package:dartz/dartz.dart';
import 'package:feature_tv/domain/repositories/tv_repository.dart';
import 'package:feature_tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/dummy_data/dummy_objects.dart';

class MockTVRepository extends Mock implements TVRepository {}

void main() {
  late RemoveWatchlistTV usecase;
  late MockTVRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockTVRepository();
    usecase = RemoveWatchlistTV(repository: mockMovieRepository);
  });

  group('RemoveWatchlistTV Tests', () {
    test(
        'should remove watchlist tv shows from repository when execute function is called',
        () async {
      // arrange
      when(() => mockMovieRepository.removeWatchlistTV(testTVDetail))
          .thenAnswer((_) async => const Right('Removed TV from Watchlist'));
      // act
      final result = await usecase.execute(testTVDetail);
      // assert
      expect(result, const Right('Removed TV from Watchlist'));
    });
  });
}

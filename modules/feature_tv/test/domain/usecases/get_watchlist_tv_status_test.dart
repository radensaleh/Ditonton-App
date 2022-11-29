import 'package:feature_tv/domain/repositories/tv_repository.dart';
import 'package:feature_tv/domain/usecases/get_watchlist_tv_status.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTVRepository extends Mock implements TVRepository {}

void main() {
  late GetWatchlistTVStatus usecase;
  late MockTVRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockTVRepository();
    usecase = GetWatchlistTVStatus(repository: mockMovieRepository);
  });

  group('GetWatchlistTVStatus Tests', () {
    test(
        'should get watchlist status from repository when execute function is called',
        () async {
      // arrange
      when(() => mockMovieRepository.isAddedToWatchlistTV(1))
          .thenAnswer((_) async => true);
      // act
      final result = await usecase.execute(1);
      // assert
      expect(result, true);
    });
  });
}

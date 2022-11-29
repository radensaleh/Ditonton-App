import 'package:dartz/dartz.dart';
import 'package:feature_tv/domain/repositories/tv_repository.dart';
import 'package:feature_tv/domain/usecases/get_tv_season_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/dummy_data/dummy_objects.dart';

class MockTVRepository extends Mock implements TVRepository {}

void main() {
  late GetTVSeasonDetail usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetTVSeasonDetail(repository: mockTVRepository);
  });

  const tvId = 1;
  const seasonNumber = 2;

  group('GetTVSeasonDetail Tests', () {
    test(
        'should get detail season tv shows the repository when execute function is called',
        () async {
      // arrange
      when(() => mockTVRepository.getSeasonDetail(tvId, seasonNumber))
          .thenAnswer((_) async => const Right(testTVSeasonDetail));
      // act
      final result = await usecase.execute(tvId, seasonNumber);
      // assert
      expect(result, const Right(testTVSeasonDetail));
    });
  });
}

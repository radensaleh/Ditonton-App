import 'package:dartz/dartz.dart';
import 'package:feature_tv/domain/repositories/tv_repository.dart';
import 'package:feature_tv/domain/usecases/get_tv_show_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/dummy_data/dummy_objects.dart';

class MockTVRepository extends Mock implements TVRepository {}

void main() {
  late GetTVShowDetail usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetTVShowDetail(repository: mockTVRepository);
  });

  const tvId = 1;

  group('GetTVShowDetail Tests', () {
    test(
        'should get detail tv shows the repository when execute function is called',
        () async {
      // arrange
      when(() => mockTVRepository.getTVShowDetail(tvId))
          .thenAnswer((_) async => const Right(testTVDetail));
      // act
      final result = await usecase.execute(tvId);
      // assert
      expect(result, const Right(testTVDetail));
    });
  });
}

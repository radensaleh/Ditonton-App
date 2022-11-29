import 'package:dartz/dartz.dart';
import 'package:feature_tv/domain/entities/tv.dart';
import 'package:feature_tv/domain/repositories/tv_repository.dart';
import 'package:feature_tv/domain/usecases/get_tv_show_recommendations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTVRepository extends Mock implements TVRepository {}

void main() {
  late GetTVShowRecommendations usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetTVShowRecommendations(repository: mockTVRepository);
  });

  const tvId = 1;
  final tTVShows = <TV>[];

  group('GetTVShowRecommendations Tests', () {
    test(
        'should get list of recommendations tv shows the repository when execute function is called',
        () async {
      // arrange
      when(() => mockTVRepository.getTVShowRecommendations(tvId))
          .thenAnswer((_) async => Right(tTVShows));
      // act
      final result = await usecase.execute(tvId);
      // assert
      expect(result, Right(tTVShows));
    });
  });
}

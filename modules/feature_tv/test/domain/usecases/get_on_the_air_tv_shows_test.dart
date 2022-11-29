import 'package:dartz/dartz.dart';
import 'package:feature_tv/domain/entities/tv.dart';
import 'package:feature_tv/domain/repositories/tv_repository.dart';
import 'package:feature_tv/domain/usecases/get_on_the_air_tv_shows.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTVRepository extends Mock implements TVRepository {}

void main() {
  late GetOnTheAirTVShows usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetOnTheAirTVShows(repository: mockTVRepository);
  });

  final tTVShows = <TV>[];

  group('GetOnTheAirTVShows Tests', () {
    test(
        'should get list of on the air tv shows from the repository when execute function is called',
        () async {
      // arrange
      when(() => mockTVRepository.getOnTheAirTVShows())
          .thenAnswer((_) async => Right(tTVShows));
      // act
      final result = await usecase.execute();
      // assert
      expect(result, Right(tTVShows));
    });
  });
}

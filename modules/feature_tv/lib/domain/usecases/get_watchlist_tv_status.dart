import 'package:feature_tv/domain/repositories/tv_repository.dart';

class GetWatchlistTVStatus {
  final TVRepository repository;

  GetWatchlistTVStatus({required this.repository});

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlistTV(id);
  }
}

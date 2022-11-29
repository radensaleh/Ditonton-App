import 'package:core/core.dart';
import 'package:feature_tv/data/models/tv_table.dart';

abstract class TVLocalDataSource {
  Future<String> insertWatchlist(TVTable tv);
  Future<String> removeWatchlist(TVTable tv);
  Future<TVTable?> getTVById(int id);
  Future<List<TVTable>> getWatchlistTVShows();
}

class TVLocalDataSourceImpl implements TVLocalDataSource {
  final DatabaseHelper databaseHelper;

  TVLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<TVTable?> getTVById(int id) async {
    final result = await databaseHelper.getTVById(id);
    if (result != null) {
      return TVTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<TVTable>> getWatchlistTVShows() async {
    final result = await databaseHelper.getWatchlistTVShows();
    return result.map((data) => TVTable.fromMap(data)).toList();
  }

  @override
  Future<String> insertWatchlist(TVTable tv) async {
    try {
      await databaseHelper.insertWatchlistTV(tv);
      return 'Added TV to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(TVTable tv) async {
    try {
      await databaseHelper.removeWatchlistTV(tv);
      return 'Removed TV from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
}

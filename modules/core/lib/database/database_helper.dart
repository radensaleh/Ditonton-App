import 'dart:async';

import 'package:feature_movie/data/models/movie_table.dart';
import 'package:feature_tv/data/models/tv_table.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  DatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._instance();

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await _initDb();
    return _database;
  }

  static const String _tblWatchlist = 'watchlist';
  static const String _tblWatchlistTV = 'watchlistTV';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/ditonton.db';

    var db = await openDatabase(databasePath, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE  $_tblWatchlist (
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE $_tblWatchlistTV (
        id INTEGER PRIMARY KEY,
        name TEXT,
        overview TEXT,
        posterPath TEXT
      );
      ''');
  }

  Future<int> insertWatchlist(MovieTable movie) async {
    final db = await database;
    return await db!.insert(_tblWatchlist, movie.toJson());
  }

  Future<int> removeWatchlist(MovieTable movie) async {
    final db = await database;
    return await db!.delete(
      _tblWatchlist,
      where: 'id = ?',
      whereArgs: [movie.id],
    );
  }

  Future<Map<String, dynamic>?> getMovieById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tblWatchlist,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(_tblWatchlist);

    return results;
  }

  // watchlist tv
  Future<int> insertWatchlistTV(TVTable tv) async {
    final db = await database;
    return await db!.insert(_tblWatchlistTV, tv.toJson());
  }

  Future<int> removeWatchlistTV(TVTable tv) async {
    final db = await database;
    return await db!.delete(
      _tblWatchlistTV,
      where: 'id = ?',
      whereArgs: [tv.id],
    );
  }

  Future<Map<String, dynamic>?> getTVById(int id) async {
    final db = await database;
    final result = await db!.query(
      _tblWatchlistTV,
      where: 'id = ?',
      whereArgs: [id],
    );

    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> getWatchlistTVShows() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db!.query(_tblWatchlistTV);

    return result;
  }
}

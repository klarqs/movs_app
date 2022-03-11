import 'dart:io';

import 'package:movs_app/app/modules/movies_home/models/movies_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'saveMovies.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE savedMovies(
        id INTEGER PRIMARY KEY,
        image TEXT 
      )
    ''');
  }

  Future<List<MoviesModel>> getSavedMovies() async {
    Database db = await instance.database;
    var savedMovies = await db.query('savedMovies', orderBy: 'id');
    List<MoviesModel> savedMoviesList = savedMovies.isNotEmpty
        ? savedMovies.map((e) => MoviesModel.fromMap(e)).toList()
        : [];
    return savedMoviesList;
  }

  Future<int> add(MoviesModel moviesModel) async {
    Database db = await instance.database;
    return await db.insert('savedMovies', moviesModel.toMap());
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(
      'savedMovies',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

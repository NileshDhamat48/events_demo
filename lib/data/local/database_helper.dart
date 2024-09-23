import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/event_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'events.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE events(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        date TEXT NOT NULL
      )
      ''',
    );
  }

  Future<int> insertEvents(Events task) async {
    final db = await database;
    return await db.insert('events', task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Events>> getEventsByMonth(int year, int month) async {
    final db = await database;
    // Format the year and month into 'yyyy-MM'
    String monthString = '$year-${month.toString().padLeft(2, '0')}';
    final List<Map<String, dynamic>> maps = await db.query(
      'events',
      where: 'date LIKE ?',
      whereArgs: ['$monthString%'], // Matches dates like 'yyyy-MM%'
    );

    return List.generate(maps.length, (i) {
      return Events(
        id: maps[i]['id'],
        title: maps[i]['title'],
        description: maps[i]['description'],
        date: DateTime.parse(maps[i]['date']),
      );
    });
  }

  Future<List<Events>> getEvents() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('events');
    return List.generate(maps.length, (i) {
      return Events(
        id: maps[i]['id'],
        title: maps[i]['title'],
        description: maps[i]['description'],
        date: DateTime.parse(maps[i]['date']),
      );
    });
  }

  Future<int> updateEvents(Events task) async {
    final db = await database;
    return await db.update(
      'events',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

}

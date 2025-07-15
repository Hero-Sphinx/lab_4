import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'list_item.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('todo.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todo(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        quantity TEXT NOT NULL
      )
    ''');
  }

  Future<List<ListItem>> getItems() async {
    final db = await instance.database;
    final maps = await db.query('todo');

    return maps.isNotEmpty
        ? maps.map((map) => ListItem.fromMap(map)).toList()
        : [];
  }

  Future<int> insertItem(ListItem item) async {
    final db = await instance.database;
    return await db.insert('todo', item.toMap());
  }

  Future<int> deleteItem(int id) async {
    final db = await instance.database;
    return await db.delete('todo', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';
import 'list_item.dart';

class ListItemDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<ListItem>> getAllItems() async {
    final db = await _dbHelper.database;
    final maps = await db.query('todo');
    return maps.isNotEmpty
        ? maps.map((map) => ListItem.fromMap(map)).toList()
        : [];
  }

  Future<int> insertItem(ListItem item) async {
    final db = await _dbHelper.database;
    return await db.insert('todo', item.toMap());
  }

  Future<int> deleteItem(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('todo', where: 'id = ?', whereArgs: [id]);
  }
}

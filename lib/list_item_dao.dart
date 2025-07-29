import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';
import 'list_item.dart';

class ListItemDao {
  Future<int> insertItem(ListItem item) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert('todo', item.toMap());  // <-- changed to 'todo'
  }

  Future<List<ListItem>> getAllItems() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query('todo');           // <-- changed to 'todo'
    return result.map((json) => ListItem.fromMap(json)).toList();
  }

  Future<int> deleteItem(int id) async {
    final db = await DatabaseHelper.instance.database;
    return await db.delete('todo', where: 'id = ?', whereArgs: [id]);  // <-- changed to 'todo'
  }
}

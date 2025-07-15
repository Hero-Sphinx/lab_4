import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'list_item.dart';
import 'list_item_dao.dart';

void main() {
  runApp(MaterialApp(home: ListPage()));
}

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  List<ListItem> _items = [];
  final ListItemDao _dao = ListItemDao();

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future _loadItems() async {
    final items = await _dao.getAllItems();
    setState(() => _items = items);
  }

  Future _addItem() async {
    final String name = _itemController.text.trim();
    final String quantity = _quantityController.text.trim();

    if (name.isNotEmpty && quantity.isNotEmpty) {
      ListItem newItem = ListItem(name: name, quantity: quantity);
      int id = await _dao.insertItem(newItem);
      newItem.id = id;
      setState(() {
        _items.add(newItem);
        _itemController.clear();
        _quantityController.clear();
      });
    }
  }

  Future _deleteItem(int index) async {
    final item = _items[index];
    if (item.id != null) {
      await _dao.deleteItem(item.id!);
      setState(() {
        _items.removeAt(index);
      });
    }
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Delete Item"),
        content: Text("Are you sure you want to delete this item?"),
        actions: [
          TextButton(
            onPressed: () {
              _deleteItem(index);
              Navigator.pop(context);
            },
            child: Text("Yes"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("No"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _itemController.dispose();
    _quantityController.dispose();
    DatabaseHelper.instance.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Shopping List")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _itemController,
                    decoration: InputDecoration(labelText: 'Type the item here'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _quantityController,
                    decoration: InputDecoration(labelText: 'Type the quantity here'),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addItem,
                  child: Text("Click here to Add"),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: _items.isEmpty
                  ? Center(child: Text("There are no items in the list"))
                  : ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onLongPress: () => _confirmDelete(index),
                    child: ListTile(
                      leading: Text("${index + 1}."),
                      title: Text(_items[index].name),
                      trailing: Text("Qty: ${_items[index].quantity}"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

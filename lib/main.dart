import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'list_item.dart';
import 'list_item_dao.dart';
import 'details_page.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

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
  ListItem? _selectedItem;

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

  Future<void> _confirmDelete(ListItem item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete "${item.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _deleteItemByItem(item);
    }
  }

  Future _deleteItemByItem(ListItem item) async {
    if (item.id != null) {
      await _dao.deleteItem(item.id!);
      setState(() {
        _items.remove(item);
        if (_selectedItem == item) _selectedItem = null;
      });
    }
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
    bool isWideScreen = MediaQuery.of(context).size.width > 600;

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
                    decoration: InputDecoration(labelText: 'Enter item name'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _quantityController,
                    decoration: InputDecoration(labelText: 'Enter quantity'),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addItem,
                  child: Text("Add"),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: isWideScreen
                  ? Row(
                children: [
                  Expanded(child: _buildListView()),
                  SizedBox(width: 20),
                  Expanded(
                    child: _selectedItem == null
                        ? Center(child: Text("Select an item to see details"))
                        : DetailsPage(
                      item: _selectedItem!,
                      onDelete: () => _confirmDelete(_selectedItem!),
                      onClose: () => setState(() => _selectedItem = null),
                    ),
                  ),
                ],
              )
                  : _selectedItem == null
                  ? _buildListView()
                  : DetailsPage(
                item: _selectedItem!,
                onDelete: () => _confirmDelete(_selectedItem!),
                onClose: () => setState(() => _selectedItem = null),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView() {
    return _items.isEmpty
        ? Center(child: Text("There are no items in the list"))
        : ListView.builder(
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return ListTile(
          onTap: () {
            setState(() {
              _selectedItem = item;
            });
          },
          leading: Text("${index + 1}."),
          title: Text(item.name),
          trailing: Text("Qty: ${item.quantity}"),
        );
      },
    );
  }
}

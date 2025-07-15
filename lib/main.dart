import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: ListPage(),
  ));
}

class ListItem {
  final String name;
  final String quantity;

  ListItem({required this.name, required this.quantity});
}

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final List<ListItem> _items = [];

  void _addItem() {
    final String name = _itemController.text.trim();
    final String quantity = _quantityController.text.trim();
    if (name.isNotEmpty && quantity.isNotEmpty) {
      setState(() {
        _items.add(ListItem(name: name, quantity: quantity));
        _itemController.clear();
        _quantityController.clear();
      });
    }
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Item"),
        content: Text("Are you sure you want to delete this item?"),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _items.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: Text("Yes"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("No"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Shopping List")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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

import 'package:flutter/material.dart';
import 'list_item.dart';

class DetailsPage extends StatelessWidget {
  final ListItem item;
  final VoidCallback onDelete;
  final VoidCallback onClose;

  const DetailsPage({
    Key? key,
    required this.item,
    required this.onDelete,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Item Details", style: Theme.of(context).textTheme.titleLarge
            ),
            SizedBox(height: 20),
            Text("ID: ${item.id ?? 'N/A'}"),
            Text("Name: ${item.name}"),
            Text("Quantity: ${item.quantity}"),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: onDelete,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text("Delete"),
                ),
                ElevatedButton(
                  onPressed: onClose,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: Text("Close"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

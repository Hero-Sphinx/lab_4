class ListItem {
  int? id;
  String name;
  String quantity;

  ListItem({this.id, required this.name, required this.quantity});

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
      'quantity': quantity,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  static ListItem fromMap(Map<String, dynamic> map) => ListItem(
    id: map['id'] as int?,
    name: map['name'] as String,
    quantity: map['quantity'] as String,
  );
}

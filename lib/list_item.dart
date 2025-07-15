class ListItem {
  int? id;
  final String name;
  final String quantity;

  ListItem({this.id, required this.name, required this.quantity});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'quantity': quantity,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  factory ListItem.fromMap(Map<String, dynamic> map) {
    return ListItem(
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'],
    );
  }
}

class FoodItem {
  final String name;
  final int cost;

  FoodItem({required this.name, required this.cost});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'cost': cost,
    };
  }

  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      name: map['name'] ?? '',
      cost: map['cost'] ?? 0,
    );
  }
}

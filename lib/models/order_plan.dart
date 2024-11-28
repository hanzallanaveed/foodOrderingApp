import 'food_item.dart';

class OrderPlan {
  final String date;
  final List<FoodItem> selectedItems;

  OrderPlan({required this.date, required this.selectedItems});

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'selectedItems': selectedItems.map((e) => e.toMap()).toList(),
    };
  }

  factory OrderPlan.fromMap(Map<String, dynamic> map) {
    return OrderPlan(
      date: map['date'],
      selectedItems: List<FoodItem>.from(map['selectedItems'].map((e) => FoodItem.fromMap(Map<String, dynamic>.from(e)))),
    );
  }
}

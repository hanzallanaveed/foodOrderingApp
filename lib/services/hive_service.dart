import 'package:hive/hive.dart';
import '../models/food_item.dart';
import '../models/order_plan.dart';

class HiveService {
  static final Box _foodBox = Hive.box('foodItems');
  static final Box _orderBox = Hive.box('orderPlans');

  void addFoodItem(FoodItem foodItem) {
    _foodBox.add(foodItem.toMap());
  }

  List<FoodItem> getFoodItems() {
    return _foodBox.values.map((e) => FoodItem.fromMap(Map<String, dynamic>.from(e))).toList();
  }

  void deleteFoodItem(int index) {
    _foodBox.deleteAt(index);
  }

  void updateFoodItem(int index, FoodItem foodItem) {
    _foodBox.putAt(index, foodItem.toMap());
  }

  void addOrderPlan(OrderPlan orderPlan) {
    _orderBox.put(orderPlan.date, orderPlan.toMap());
  }

  OrderPlan? getOrderPlan(String date) {
    final Map<String, dynamic>? result = _orderBox.get(date);
    return result != null ? OrderPlan.fromMap(result) : null;
  }
}

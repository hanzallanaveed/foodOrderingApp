import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/home_screen.dart';
import 'screens/add_food_screen.dart';
import 'services/hive_service.dart';
import 'models/food_item.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('foodItems');
  await Hive.openBox('orderPlans');
  _initializeDefaultFoodItems(); // Initialize with default food items
  runApp(MyApp());
}

void _initializeDefaultFoodItems() {
  final defaultItems = [
    FoodItem(name: 'Pizza', cost: 10),
    FoodItem(name: 'Burger', cost: 5),
    FoodItem(name: 'Pasta', cost: 8),
    FoodItem(name: 'Sandwich', cost: 4),
    FoodItem(name: 'Fries', cost: 3),
    FoodItem(name: 'Ice Cream', cost: 6),
    FoodItem(name: 'Salad', cost: 7),
    FoodItem(name: 'Sushi', cost: 12),
    FoodItem(name: 'Soup', cost: 5),
    FoodItem(name: 'Chicken Wings', cost: 9),
    FoodItem(name: 'Steak', cost: 15),
    FoodItem(name: 'Tacos', cost: 6),
    FoodItem(name: 'Curry', cost: 11),
    FoodItem(name: 'Dumplings', cost: 8),
    FoodItem(name: 'Hot Dog', cost: 4),
    FoodItem(name: 'Lasagna', cost: 10),
    FoodItem(name: 'Kebab', cost: 9),
    FoodItem(name: 'Noodles', cost: 7),
    FoodItem(name: 'Fried Rice', cost: 6),
    FoodItem(name: 'Smoothie', cost: 5),
  ];

  final hiveService = HiveService();
  if (hiveService.getFoodItems().isEmpty) {
    for (var item in defaultItems) {
      hiveService.addFoodItem(item);
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Ordering App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/add_food': (context) => AddFoodScreen(),
      },
    );
  }
}

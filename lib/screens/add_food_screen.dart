import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../services/hive_service.dart';

class AddFoodScreen extends StatefulWidget {
  final FoodItem? foodItem;
  final int? index;

  AddFoodScreen({this.foodItem, this.index});

  @override
  _AddFoodScreenState createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final HiveService _hiveService = HiveService();

  @override
  void initState() {
    super.initState();
    if (widget.foodItem != null) {
      _nameController.text = widget.foodItem!.name;
      _costController.text = widget.foodItem!.cost.toString();
    }
  }

  void _addOrUpdateFoodItem() {
    String name = _nameController.text;
    int? cost = int.tryParse(_costController.text);

    if (name.isNotEmpty && cost != null) {
      FoodItem foodItem = FoodItem(name: name, cost: cost);
      if (widget.foodItem == null) {
        _hiveService.addFoodItem(foodItem);
      } else {
        _hiveService.updateFoodItem(widget.index!, foodItem);
      }
      Navigator.pop(context, true); // Return to previous screen with success flag
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter valid name and cost')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.foodItem == null ? 'Add Food Item' : 'Edit Food Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Food Name'),
            ),
            TextField(
              controller: _costController,
              decoration: InputDecoration(labelText: 'Cost'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addOrUpdateFoodItem,
              child: Text(widget.foodItem == null ? 'Add' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }
}

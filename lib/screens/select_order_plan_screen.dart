import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/hive_service.dart';
import '../models/food_item.dart';
import '../models/order_plan.dart';

class SelectOrderPlanScreen extends StatefulWidget {
  @override
  _SelectOrderPlanScreenState createState() => _SelectOrderPlanScreenState();
}

class _SelectOrderPlanScreenState extends State<SelectOrderPlanScreen> {
  final HiveService _hiveService = HiveService();
  final TextEditingController _targetCostController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  List<FoodItem> _foodItems = [];
  List<FoodItem> _selectedItems = [];
  double _remainingCost = 0.0;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _foodItems = _hiveService.getFoodItems();
    _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
  }

  void _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
      });
    }
  }

  void _saveOrderPlan() {
    final targetCost = double.tryParse(_targetCostController.text) ?? 0.0;

    if (_selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least one food item')),
      );
      return;
    }

    final totalCost = _selectedItems.fold(0, (sum, item) => sum + item.cost);

    if (totalCost > targetCost) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Total cost exceeds target cost')),
      );
      return;
    }

    final orderPlan = OrderPlan(
      date: _dateController.text,
      selectedItems: _selectedItems,
    );

    _hiveService.addOrderPlan(orderPlan);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order plan saved successfully')),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Order Plan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Date',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: _selectDate,
                ),
              ),
              readOnly: true,
            ),
            TextField(
              controller: _targetCostController,
              decoration: InputDecoration(labelText: 'Target Cost per Day'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Text('Select Food Items:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: _foodItems.length,
                itemBuilder: (context, index) {
                  final foodItem = _foodItems[index];
                  final isSelected = _selectedItems.contains(foodItem);

                  return CheckboxListTile(
                    title: Text(foodItem.name),
                    subtitle: Text('\$${foodItem.cost}'),
                    value: isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedItems.add(foodItem);
                        } else {
                          _selectedItems.remove(foodItem);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            Text(
              'Total Selected Cost: \$${_selectedItems.fold(0, (sum, item) => sum + item.cost)}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveOrderPlan,
              child: Text('Save Order Plan'),
            ),
          ],
        ),
      ),
    );
  }
}
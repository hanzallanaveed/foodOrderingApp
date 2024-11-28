import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../services/hive_service.dart';
import 'add_food_screen.dart';
import 'select_order_plan_screen.dart';
import 'query_order_plan_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HiveService _hiveService = HiveService();
  List<FoodItem> _foodItems = [];

  @override
  void initState() {
    super.initState();
    _loadFoodItems();
  }

  void _loadFoodItems() {
    setState(() {
      _foodItems = _hiveService.getFoodItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Food Ordering App')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: Text('Food Items'),
                  trailing: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () async {
                      bool? result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddFoodScreen()),
                      );
                      if (result == true) {
                        _loadFoodItems();
                      }
                    },
                  ),
                ),
                _foodItems.isEmpty
                    ? Center(child: Text('No food items found.'))
                    : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _foodItems.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_foodItems[index].name),
                      subtitle: Text('Cost: \$${_foodItems[index].cost}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddFoodScreen(
                                    foodItem: _foodItems[index],
                                    index: index,
                                  ),
                                ),
                              ).then((_) => _loadFoodItems());
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                _hiveService.deleteFoodItem(index);
                                _loadFoodItems();
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectOrderPlanScreen(),
                        ),
                      );
                    },
                    child: Text('Create Order Plan'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QueryOrderPlanScreen(),
                        ),
                      );
                    },
                    child: Text('Query Order Plan'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
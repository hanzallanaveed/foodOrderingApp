import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/order_plan.dart';
import '../services/hive_service.dart';

class ViewOrderPlanScreen extends StatefulWidget {
  @override
  _ViewOrderPlanScreenState createState() => _ViewOrderPlanScreenState();
}

class _ViewOrderPlanScreenState extends State<ViewOrderPlanScreen> {
  final HiveService _hiveService = HiveService();
  DateTime _selectedDate = DateTime.now();
  OrderPlan? _orderPlan;

  void _queryOrderPlan() {
    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
    setState(() {
      _orderPlan = _hiveService.getOrderPlan(formattedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('View Order Plan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Text('Select Date: '),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        setState(() {
                          _selectedDate = date;
                          _orderPlan = null; // Reset the order plan when a new date is selected.
                        });
                      }
                    },
                    child: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _queryOrderPlan,
                ),
              ],
            ),
            SizedBox(height: 16),
            if (_orderPlan != null)
              Expanded(
                child: ListView.builder(
                  itemCount: _orderPlan!.selectedItems.length,
                  itemBuilder: (context, index) {
                    final item = _orderPlan!.selectedItems[index];
                    return ListTile(
                      title: Text(item.name),
                      subtitle: Text('Cost: \$${item.cost}'),
                    );
                  },
                ),
              )
            else if (_orderPlan == null)
              Center(child: Text('No order plan found for the selected date.')),
          ],
        ),
      ),
    );
  }
}

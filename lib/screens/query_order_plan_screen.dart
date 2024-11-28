import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/hive_service.dart';
import '../models/order_plan.dart';

class QueryOrderPlanScreen extends StatefulWidget {
  @override
  _QueryOrderPlanScreenState createState() => _QueryOrderPlanScreenState();
}

class _QueryOrderPlanScreenState extends State<QueryOrderPlanScreen> {
  final HiveService _hiveService = HiveService();
  final TextEditingController _dateController = TextEditingController();
  OrderPlan? _orderPlan;
  DateTime _selectedDate = DateTime.now();

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
        _queryOrderPlan();
      });
    }
  }

  void _queryOrderPlan() {
    final orderPlan = _hiveService.getOrderPlan(_dateController.text);
    setState(() {
      _orderPlan = orderPlan;
    });
  }

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Query Order Plan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Select Date',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: _selectDate,
                ),
              ),
              readOnly: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _queryOrderPlan,
              child: Text('Query Order Plan'),
            ),
            SizedBox(height: 20),
            _orderPlan != null
                ? Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Plan for ${_orderPlan!.date}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _orderPlan!.selectedItems.length,
                      itemBuilder: (context, index) {
                        final item = _orderPlan!.selectedItems[index];
                        return ListTile(
                          title: Text(item.name),
                          subtitle: Text('\$${item.cost}'),
                        );
                      },
                    ),
                  ),
                  Text(
                    'Total Cost: \$${_orderPlan!.selectedItems.fold(0, (sum, item) => sum + item.cost)}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
                : Text(
              'No order plan found for the selected date.',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
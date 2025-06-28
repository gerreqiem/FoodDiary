import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/food_service.dart';
class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});
  @override
  _StatsScreenState createState() => _StatsScreenState();
}
class _StatsScreenState extends State<StatsScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final foodService = Provider.of<FoodService>(context);
    final calories = foodService.getTotalCaloriesForDay(_selectedDate);
    final protein = foodService.getTotalProteinForDay(_selectedDate);
    final fat = foodService.getTotalFatForDay(_selectedDate);
    final carbs = foodService.getTotalCarbsForDay(_selectedDate);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daily Stats',
          style: TextStyle(color: Colors.white), 
        ),
        backgroundColor: Color(0xFF1E3A8A), 
        iconTheme: const IconThemeData(color: Colors.white), 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text(
                DateFormat('EEEE, d MMMM', 'en_US').format(_selectedDate),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_today, color: Colors.black),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != _selectedDate) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            _buildStatTile('Calories', calories, Colors.orange, 'kcal'),
            _buildStatTile('Protein', protein, Colors.blue, 'g'),
            _buildStatTile('Fat', fat, Colors.purple, 'g'),
            _buildStatTile('Carbs', carbs, Colors.teal, 'g'),
          ],
        ),
      ),
    );
  }
  Widget _buildStatTile(String label, double value, Color color, String unit) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
        trailing: Text('${value.toStringAsFixed(0)} $unit', style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}

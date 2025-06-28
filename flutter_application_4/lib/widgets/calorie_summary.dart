import 'package:flutter/material.dart';
class CalorieSummary extends StatelessWidget {
  final double totalCalories;
  final double totalProtein;
  final double totalFat;
  final double totalCarbs;
  const CalorieSummary({
    super.key,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalFat,
    required this.totalCarbs,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Total',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Calories: ${totalCalories.toStringAsFixed(0)} kcal'),
            Text('Proteins: ${totalProtein.toStringAsFixed(0)} g'),
            Text('Fats: ${totalFat.toStringAsFixed(0)} g'),
            Text('Carbs: ${totalCarbs.toStringAsFixed(0)} g'),
          ],
        ),
      ),
    );
  }
}
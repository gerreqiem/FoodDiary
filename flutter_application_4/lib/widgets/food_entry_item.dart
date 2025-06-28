import 'package:flutter/material.dart';
import '../models/food_entry.dart';
import 'package:intl/intl.dart';
class FoodEntryItem extends StatelessWidget {
  final FoodEntry entry;
  final VoidCallback onRemove;
  const FoodEntryItem({
    super.key,
    required this.entry,
    required this.onRemove,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
        title: Text(entry.foodItem.name),
        subtitle: Text(
          '${DateFormat('HH:mm').format(entry.dateTime)}\n'
          '${entry.quantity.round()} ${entry.foodItem.servingUnit}\n'
          '${entry.mealType.name}\n' 
          'Calories: ${entry.calculatedCalories.toStringAsFixed(0)} kcal\n'
          'Proteins: ${entry.calculatedProtein.toStringAsFixed(0)} g\n'
          'Fats: ${entry.calculatedFat.toStringAsFixed(0)} g\n'
          'Carbs: ${entry.calculatedCarbs.toStringAsFixed(0)} g',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onRemove,
        ),
      ),
    );
  }
}
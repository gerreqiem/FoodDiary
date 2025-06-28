import 'package:flutter/material.dart';
import '../models/food_entry.dart';
import 'food_entry_item.dart';
class FoodList extends StatelessWidget {
  final List<FoodEntry> entries;
  final Function(FoodEntry) onRemove;
  const FoodList({
    super.key,
    required this.entries,
    required this.onRemove,
  });
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return FoodEntryItem(
          entry: entry,
          onRemove: () => onRemove(entry),
        );
      },
    );
  }
}
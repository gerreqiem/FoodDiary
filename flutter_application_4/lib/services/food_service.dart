import 'package:flutter/foundation.dart';
import '../models/food_item.dart';
import '../models/food_entry.dart';
import 'database_helper.dart';
class FoodService with ChangeNotifier {
  List<FoodItem> _foodItems = [];
  final List<FoodEntry> _foodEntries = [];
  List<FoodItem> get foodItems => _foodItems;
  List<FoodEntry> get foodEntries => _foodEntries;
  Future<void> loadFoodItems() async {
    final dbItems = await DatabaseHelper.instance.getFoodItems();
    _foodItems = dbItems.map((item) => FoodItem.fromMap(item)).toList();
  }
  Future<void> loadFoodEntries() async {
    _foodEntries.clear();
    final entries = await DatabaseHelper.instance.getFoodEntries(_foodItems);
    _foodEntries.addAll(entries);
    notifyListeners();
  }
  List<FoodItem> getPopularFoods() {
    return _foodItems;
  }
  Future<void> addFoodEntry(FoodEntry entry) async {
    await DatabaseHelper.instance.insertFoodEntry(entry);
    _foodEntries.add(entry);
    notifyListeners();
  }
  Future<void> removeFoodEntry(FoodEntry entry) async {
    await DatabaseHelper.instance.deleteFoodEntry(entry.id);
    _foodEntries.removeWhere((element) => element.id == entry.id);
    notifyListeners();
  }
  double getTotalCalories(DateTime date, [MealType? mealType]) {
    return _calculateTotal(date, mealType, (entry) => entry.calculatedCalories);
  }
  double getTotalProtein(DateTime date, [MealType? mealType]) {
    return _calculateTotal(date, mealType, (entry) => entry.calculatedProtein);
  }
  double getTotalFat(DateTime date, [MealType? mealType]) {
    return _calculateTotal(date, mealType, (entry) => entry.calculatedFat);
  }
  double getTotalCarbs(DateTime date, [MealType? mealType]) {
    return _calculateTotal(date, mealType, (entry) => entry.calculatedCarbs);
  }
  double _calculateTotal(DateTime date, MealType? mealType, double Function(FoodEntry) getValue) {
    return _foodEntries
        .where((entry) =>
            entry.dateTime.year == date.year &&
            entry.dateTime.month == date.month &&
            entry.dateTime.day == date.day &&
            (mealType == null || entry.mealType == mealType))
        .map(getValue)
        .fold(0.0, (sum, value) => sum + value);
  }
  double getTotalCaloriesForDay(DateTime date) => getTotalCalories(date);
  double getTotalProteinForDay(DateTime date) => getTotalProtein(date);
  double getTotalFatForDay(DateTime date) => getTotalFat(date);
  double getTotalCarbsForDay(DateTime date) => getTotalCarbs(date);
}

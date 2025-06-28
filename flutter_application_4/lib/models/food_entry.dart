import 'food_item.dart';
enum MealType { breakfast, lunch, dinner, snack }
class FoodEntry {
  final String id;
  final FoodItem foodItem;
  final DateTime dateTime;
  final double quantity;
  final MealType mealType;
  FoodEntry({
    required this.id,
    required this.foodItem,
    required this.dateTime,
    required this.quantity,
    required this.mealType,
  });
  double get calculatedCalories => foodItem.calories * quantity / 100;
  double get calculatedProtein => foodItem.protein * quantity / 100;
  double get calculatedFat => foodItem.fat * quantity / 100;
  double get calculatedCarbs => foodItem.carbs * quantity / 100;
}

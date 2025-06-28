class FoodItem {
  final String id;
  final String name;
  final double calories;
  final double protein;
  final double fat;
  final double carbs;
  final String servingUnit;
  FoodItem({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.servingUnit,
  });
  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      id: map['id'].toString(),
      name: map['name'],
      calories: map['calories'].toDouble(),
      protein: map['protein'].toDouble(),
      fat: map['fat'].toDouble(),
      carbs: map['carbs'].toDouble(),
      servingUnit: map['servingUnit'] ?? 'g',
    );
  }
}

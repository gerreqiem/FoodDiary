import 'package:flutter_application_3/screens/add_food_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_3/models/food_entry.dart';
import 'package:flutter_application_3/services/food_service.dart';
import 'package:flutter_application_3/widgets/calorie_summary.dart';
import 'package:flutter_application_3/widgets/food_list.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_3/screens/help_screen.dart';  
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateTime.now();
  MealType _selectedMealType = MealType.breakfast;
  @override
  Widget build(BuildContext context) {
    final foodService = Provider.of<FoodService>(context);
    return Scaffold(
      backgroundColor: Colors.grey[200], 
      appBar: AppBar(
        title: const Text(
          'Food Diary',
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 22, 
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF1E3A8A), 
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.white),
            onPressed: () async {
              final DateTime? picked = await showDatePicker(
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
          IconButton(
            icon: const Icon(Icons.bar_chart, color: Colors.white), 
            onPressed: () {
              Navigator.pushNamed(context, '/stats'); 
            },
          ),
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white), 
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpScreen()), 
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      DateFormat('EEEE, d MMMM', 'en_US').format(_selectedDate),
                      style: const TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold, 
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: MealType.values.map((meal) {
                          return ChoiceChip(
                            label: Text(mealToString(meal)),
                            selected: _selectedMealType == meal,
                            onSelected: (selected) {
                              setState(() {
                                _selectedMealType = meal;
                              });
                            },
                            selectedColor: Color(0xFF3B82F6),
                            labelStyle: TextStyle(
                              color: _selectedMealType == meal 
                                  ? Colors.white 
                                  : Colors.black,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          CalorieSummary(
            totalCalories: foodService.getTotalCalories(_selectedDate, _selectedMealType),
            totalProtein: foodService.getTotalProtein(_selectedDate, _selectedMealType),
            totalFat: foodService.getTotalFat(_selectedDate, _selectedMealType),
            totalCarbs: foodService.getTotalCarbs(_selectedDate, _selectedMealType),
          ),
          Expanded(
            child: FoodList(
              entries: foodService.foodEntries
                  .where((entry) =>
                      entry.dateTime.year == _selectedDate.year &&
                      entry.dateTime.month == _selectedDate.month &&
                      entry.dateTime.day == _selectedDate.day &&
                      entry.mealType == _selectedMealType)
                  .toList(),
              onRemove: (FoodEntry entry) {
                foodService.removeFoodEntry(entry);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddFoodScreen(
                popularFoods: foodService.getPopularFoods(),
                selectedDate: _selectedDate,
                selectedMealType: _selectedMealType,
              ),
            ),
          );
          if (result != null) {
            foodService.addFoodEntry(result);
          }
        },
        backgroundColor: Color(0xFF1E3A8A), 
        shape: CircleBorder(), 
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
  String mealToString(MealType meal) {
    switch (meal) {
      case MealType.breakfast:
        return 'Breakfast';
      case MealType.lunch:
        return 'Lunch';
      case MealType.dinner:
        return 'Dinner';
      case MealType.snack:
        return 'Snack';
      default:
        return '';
    }
  }
}

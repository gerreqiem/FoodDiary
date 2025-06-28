import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../models/food_entry.dart';
import '../services/database_helper.dart';

class AddFoodScreen extends StatefulWidget {
  final DateTime selectedDate;
  final MealType selectedMealType;
  final List<FoodItem> popularFoods;

  const AddFoodScreen({
    super.key,
    required this.selectedDate,
    required this.selectedMealType,
    required this.popularFoods,
  });

  @override
  _AddFoodScreenState createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  List<FoodItem> _foodItems = [];
  FoodItem? _selectedFood;
  double _quantity = 100;
  final TextEditingController _quantityController = TextEditingController();
  double _maxQuantity = 500;

  @override
  void initState() {
    super.initState();
    _loadFoodItems();
    _quantityController.text = _quantity.toStringAsFixed(0);
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _loadFoodItems() async {
    final items = await DatabaseHelper.instance.getFoodItems();
    setState(() {
      _foodItems = items.map((item) => FoodItem.fromMap(item)).toList();
    });
  }

  double _getMaxQuantity(FoodItem food) {
    final name = food.name.toLowerCase();
    if (name.contains('масло')) return 200;
    if (name.contains('орех')) return 200;
    if (name.contains('сыр')) return 300;
    if (name.contains('вода')) return 1000;
    if (name.contains('овощ') || name.contains('фрукт')) return 1000;
    return 500;
  }

  void _updateQuantity(String value) {
    final newQuantity = double.tryParse(value) ?? _quantity;
    setState(() {
      _quantity = newQuantity.clamp(1, _maxQuantity);
      _quantityController.text = _quantity.toStringAsFixed(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add a product',
          style: TextStyle(color: Colors.white), 
        ),
        backgroundColor: Color(0xFF1E3A8A),
        elevation: 5,
        iconTheme: const IconThemeData(color: Colors.white), 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<FoodItem>(
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              hint: const Text('Select a product'),
              value: _selectedFood,
              items: widget.popularFoods.map((food) {
                return DropdownMenuItem<FoodItem>(
                  value: food,
                  child: Text(food.name),
                );
              }).toList(),
              onChanged: (FoodItem? value) {
                if (value != null) {
                  setState(() {
                    _selectedFood = value;
                    _maxQuantity = _getMaxQuantity(value);
                    if (_quantity > _maxQuantity) {
                      _quantity = _maxQuantity;
                      _quantityController.text = _quantity.toStringAsFixed(0);
                    }
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Reference portion: ${_quantity.round()} g',
              style: const TextStyle(fontSize: 16),
            ),
            if (_selectedFood != null) ...[
              const SizedBox(height: 4),
              Text(
                _getPortionHint(_selectedFood!),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Color(0xFF3B82F6), 
                thumbColor: Color(0xFF3B82F6),
                overlayColor: Color(0xFF3B82F6).withOpacity(0.2),
              ),
              child: Slider(
                value: _quantity,
                min: 1,
                max: _maxQuantity,
                divisions: (_maxQuantity / 5).round(),
                label: _quantity.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _quantity = value;
                    _quantityController.text = value.toStringAsFixed(0);
                  });
                },
              ),
            ),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(
                labelText: 'Amount (g)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixText: 'g',
                hintText: '1–${_maxQuantity.round()}',
              ),
              keyboardType: TextInputType.number,
              onChanged: _updateQuantity,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1E3A8A), 
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _selectedFood != null
                    ? () {
                        Navigator.pop(
                          context,
                          FoodEntry(
                            id: DateTime.now().toString(),
                            foodItem: _selectedFood!,
                            dateTime: widget.selectedDate,
                            quantity: _quantity,
                            mealType: widget.selectedMealType,
                          ),
                        );
                      }
                    : null,
                child: const Text(
                  'Add',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  String _getPortionHint(FoodItem food) {
    final name = food.name.toLowerCase();
    if (name.contains('масло')) return 'Tip: 1 tbsp ≈ 15 g';
    if (name.contains('орех')) return 'Tip: 1 handful ≈ 30 g';
    if (name.contains('вода')) return 'Tip: 1 glass ≈ 200 ml';
    if (name.contains('сыр')) return 'Tip: 1 slice ≈ 30 g';
    if (name.contains('яблоко')) return 'Tip: 1 medium ≈ 150 g';
    return 'Recommended range: 1–${_maxQuantity.round()} г';
  }
}

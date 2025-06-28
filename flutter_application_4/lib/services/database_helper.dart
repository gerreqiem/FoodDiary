import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import '../models/food_entry.dart';
import '../models/food_item.dart';
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }
  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'food_database.db');
    bool exists = await databaseExists(path);
    if (!exists) {
      ByteData data = await rootBundle.load('assets/food_database.db');
      List<int> bytes = data.buffer.asUint8List();
      await File(path).writeAsBytes(bytes);
    }
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) async {
        await createTables(db);
      },
    );
  }
  Future<void> createTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS food_entries (
        id TEXT PRIMARY KEY,
        food_id INTEGER NOT NULL,
        dateTime TEXT NOT NULL,
        quantity REAL NOT NULL,
        mealType TEXT NOT NULL
      )
    ''');
  }
  Future<List<Map<String, dynamic>>> getFoodItems() async {
    final db = await instance.database;
    return await db.query('food_items');
  }
  Future<void> insertFoodEntry(FoodEntry entry) async {
    final db = await database;
    await db.insert('food_entries', {
      'id': entry.id,
      'food_id': entry.foodItem.id,
      'dateTime': entry.dateTime.toIso8601String(),
      'quantity': entry.quantity,
      'mealType': entry.mealType.toString().split('.').last,
    });
  }
  Future<void> deleteFoodEntry(String id) async {
    final db = await database;
    await db.delete('food_entries', where: 'id = ?', whereArgs: [id]);
  }
  Future<List<FoodEntry>> getFoodEntries(List<FoodItem> foodItems) async {
    final db = await database;
    final result = await db.query('food_entries');
    return result.map((e) {
      final food = foodItems.firstWhere(
        (f) => f.id == e['food_id'].toString(),
        orElse: () => FoodItem(
          id: e['food_id'].toString(),
          name: 'Неизвестный продукт',
          calories: 0,
          protein: 0,
          fat: 0,
          carbs: 0,
          servingUnit: 'г', 
        ),
      );
      return FoodEntry(
        id: e['id'] as String,
        foodItem: food,
        dateTime: DateTime.parse(e['dateTime'] as String),
        quantity: e['quantity'] as double,
        mealType: MealType.values.firstWhere(
          (m) => m.toString().split('.').last == e['mealType'],
        ),
      );
    }).toList();
  }
}

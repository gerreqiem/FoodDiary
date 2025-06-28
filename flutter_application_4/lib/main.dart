import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/food_service.dart';
import 'screens/home_screen.dart';
import 'screens/stats_screen.dart';
import 'screens/help_screen.dart'; // Импортируем HelpScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppInitializer());
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});
  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  late FoodService foodService;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    foodService = FoodService();
    _initialize();
  }

  Future<void> _initialize() async {
    await foodService.loadFoodItems();
    await foodService.loadFoodEntries();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return ChangeNotifierProvider(
      create: (_) => foodService,
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Diary',
      theme: ThemeData(
        primaryColor: const Color(0xFF4CAF50),
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),
        fontFamily: 'OpenSans',
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontFamily: 'RobotoCondensed',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: TextStyle(fontSize: 16),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFF8BC34A),
        ),
      ),
      home: const HomeScreen(),
      routes: {
        '/stats': (context) => const StatsScreen(),
        '/help': (context) => const HelpScreen(), // Добавляем маршрут для HelpScreen
      },
    );
  }
}

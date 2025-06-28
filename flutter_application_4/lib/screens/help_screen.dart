import 'package:flutter/material.dart';
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Help & Tips',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: const Color(0xFF1E3A8A), 
        elevation: 5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.grey[200], 
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Developer Contact:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'If you have any questions or suggestions, feel free to reach out to the developer at: \ngerreqiem@gmail.com',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Nutrition Tips:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '1. Stay hydrated by drinking water throughout the day.\n\n2. Include a variety of fruits and vegetables in your meals.\n\n3. Make sure to balance proteins, carbs, and fats in each meal.\n\n4. Avoid processed foods and sugary drinks for better health.\n\n5. Regular exercise is key to maintaining a healthy lifestyle.',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

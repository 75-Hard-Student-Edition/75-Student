import 'package:flutter/material.dart';
import 'package:student_75/userInterfaces/category_ranking.dart';

class DifficultyPage extends StatelessWidget {
  const DifficultyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F7F8),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          // Back Button (Align to top-left)
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, size: 30),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),

          const SizedBox(height: 20), // Space between back button and text
          // Title Text
          Text(
            "Select your difficulty...",
            style: TextStyle(
              fontFamily: 'KdamThmorPro',
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.teal[700],
            ),
          ),

          const SizedBox(height: 70), // Reduce space between text and buttons
          // Buttons
          buttonWidget("EASY", Colors.green),
          const SizedBox(height: 65), // Adjust spacing between buttons
          buttonWidget("MEDIUM", Colors.amber),
          const SizedBox(height: 65),
          buttonWidget("HARD", Colors.red),

          const SizedBox(height: 40),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CategoryRankingScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 17, 174, 145),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "NEXT",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'kdamThmorPro',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buttonWidget(String text, Color color) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'KdamThmorPro',
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

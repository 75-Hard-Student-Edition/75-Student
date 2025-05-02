import 'package:flutter/material.dart';
import 'package:student_75/Components/account_manager/account_manager.dart';
import 'package:student_75/models/user_account_model.dart';
import 'package:student_75/userInterfaces/category_ranking.dart';
import 'package:student_75/models/difficulty_enum.dart';

class DifficultyPage extends StatefulWidget {
  final AccountManager accountManager;
  final UserAccountModel signUpFlowState;
  final String password;
  const DifficultyPage(
      {super.key,
      required this.accountManager,
      required this.signUpFlowState,
      required this.password});

  @override
  State<DifficultyPage> createState() => _DifficultyPageState();
}

class _DifficultyPageState extends State<DifficultyPage> {
  Difficulty? selectedDifficulty;

  Color darkenColor(Color color, double amount) {
    return Color.fromRGBO(
      (color.red * (1 - amount)).round(),
      (color.green * (1 - amount)).round(),
      (color.blue * (1 - amount)).round(),
      1,
    );
  }

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
                icon: const Icon(Icons.arrow_back_ios,
                    color: Color(0xFF00A59B), size: 30),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),

          const SizedBox(height: 20), // Space between back button and text
          // Title Text
          const Text(
            "Select your difficulty...",
            style: TextStyle(
              fontFamily: 'KdamThmorPro',
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00B3A1),
            ),
          ),

          const SizedBox(height: 70),
          // Buttons
          buttonWidget("EASY", const Color(0xFF43C737), Difficulty.easy),
          const SizedBox(height: 30),
          buttonWidget("MEDIUM", const Color(0xFFEDBF45), Difficulty.medium),
          const SizedBox(height: 30),
          buttonWidget("HARD", const Color(0xFFFF4F4F), Difficulty.hard),
        ],
      ),
    );
  }

  Widget buttonWidget(String text, Color color, Difficulty difficulty) {
    final bool isSelected = selectedDifficulty == difficulty;

    return SizedBox(
      width: 275,
      height: 100,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedDifficulty = difficulty;
          });
          debugPrint("difficulty: $difficulty");
          debugPrint("backend value : ${difficulty.value}");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryRankingScreen(
                difficulty: difficulty,
                accountManager: super.widget.accountManager,
                signUpFlowState: super.widget.signUpFlowState.copyWith(
                      difficulty: selectedDifficulty,
                    ),
                password: super.widget.password,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? darkenColor(color, 0.3) : color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

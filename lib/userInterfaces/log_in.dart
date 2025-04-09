import 'package:flutter/material.dart';
import 'package:student_75/userInterfaces/start_up.dart';
import 'package:student_75/userInterfaces/sign_up.dart';
import 'package:student_75/userInterfaces/home.dart';
import 'package:student_75/models/difficulty_enum.dart';
import 'package:student_75/models/task_model.dart';

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F7F7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Back Arrow
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios,color: Color(0xFF00A59B)),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Title
                const Center(
                  child: Text(
                    '75 Student',
                    style: TextStyle(
                      fontFamily: 'KdamThmorPro',
                      fontSize: 50,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Subtitle
                const Center(
                  child: Text(
                    'Log In',
                    style: TextStyle(
                      fontFamily: 'KdamThmorPro',
                      fontSize: 24, 
                      color: Color(0xFF00B3A1)
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                const SizedBox(height: 40),
                // Inputs
                _buildInputField('Mobile/Email/Username'),
                const SizedBox(height: 20),
                _buildInputField('Password', isPassword: true),

                const SizedBox(height: 20),
                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? ",
                        style: TextStyle(color: Colors.grey)),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpScreen()),
                      ),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color:Color(0xFF38B6A2),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
                // Log In Button
                Center(
                    child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ScheduleScreen(
                          difficulty: Difficulty.medium,
                          topCategory: TaskCategory.academic,
                        )),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00B3A1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 6,
                      shadowColor: Colors.black38,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "Log In",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String hintText, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Color(0xFFAFA9A9)),
            filled: true,
            fillColor: const Color(0xFFEBEFF0),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
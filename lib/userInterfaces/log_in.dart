import 'package:flutter/material.dart';
import 'package:student_75/Components/account_manager/account_manager.dart';
import 'package:student_75/models/difficulty_enum.dart';
import 'package:student_75/models/task_model.dart';
import 'package:student_75/models/user_account_model.dart';
import 'package:student_75/userInterfaces/start_up.dart';
import 'package:student_75/userInterfaces/sign_up.dart';
import 'package:student_75/userInterfaces/home.dart';
import 'package:student_75/app_settings.dart';
//import 'package:student_75/models/difficulty_enum.dart';
//import 'package:student_75/models/task_model.dart';

class LogInScreen extends StatefulWidget {
  final AccountManager accountManager;
  LogInScreen({super.key, required this.accountManager});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  late final Widget _usernameField = Padding(
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
        controller: _usernameController,
        obscureText: false,
        decoration: InputDecoration(
          hintText: 'Mobile/Email/Username',
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

  late final Widget _passwordField = Padding(
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
        controller: _passwordController,
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Password',
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

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
                  icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF00A59B)),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => WelcomeScreen()),
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
                        fontFamily: 'KdamThmorPro', fontSize: 24, color: Color(0xFF00B3A1)),
                  ),
                ),
                const SizedBox(height: 32),

                const SizedBox(height: 40),
                // Inputs
                _usernameField,
                const SizedBox(height: 20),
                _passwordField,

                const SizedBox(height: 20),
                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? ", style: TextStyle(color: Colors.grey)),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignUpScreen(
                                  accountManager: widget.accountManager,
                                )),
                      ),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Color(0xFF38B6A2),
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
                    onPressed: () async {
                      // Log in to the account using the AccountManager
                      try {
                        await widget.accountManager.login(
                          _usernameController.text,
                          _passwordController.text,
                        );
                      } on AccountNotFoundException catch (e) {
                        // Handle login error (e.g., show a dialog or snackbar)
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Login failed: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      // Navigate to the ScheduleScreen after logging in
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ScheduleScreen(
                                  accountManager: widget.accountManager,
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
                const SizedBox(height: 40),
                // Log in with demo user button
                Center(
                  child: TextButton(
                    onPressed: () async {
                      try {
                        await widget.accountManager.login(_usernameController.text, _passwordController.text);
                      } on AccountNotFoundException catch (e) {
                        // Create demo account if it doesn't exist
                        UserAccountModel demoAccount = UserAccountModel(
                          id: 0,
                          username: "demo",
                          email: "demo@demo.demo",
                          phoneNumber: "0000000000",
                          streak: 25,
                          difficulty: Difficulty.easy,
                          categoryOrder: [
                            TaskCategory.academic,
                            TaskCategory.chore,
                            TaskCategory.employment,
                            TaskCategory.health,
                            TaskCategory.hobby,
                            TaskCategory.social,
                          ],
                          sleepDuration: Duration(hours: AppSettings.defaultSleepDuration),
                          bedtime: DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                            AppSettings.defaultBedtimeHour,
                            AppSettings.defaultBedtimeMinute,
                          ),
                          bedtimeNotifyBefore: Duration(hours: 1),
                          mindfulnessDuration:
                              Duration(minutes: AppSettings.defaultMindfulnessDuration),
                        );
                        await widget.accountManager.createAccount(demoAccount, "demo");
                        await widget.accountManager.login("demo", "demo");
                      }

                      // Navigate to the ScheduleScreen after logging in
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ScheduleScreen(
                                  accountManager: widget.accountManager,
                                )),
                      );
                    },
                    child: const Text(
                      "Log in with demo user",
                      style: TextStyle(
                        color: Color(0xFFAFA9A9),
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Color(0xFFAFA9A9),
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
}

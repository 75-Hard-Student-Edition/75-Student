import 'package:flutter/material.dart';
import 'package:student_75/userInterfaces/log_in.dart';
import 'package:student_75/userInterfaces/sign_up.dart';
import 'package:student_75/Components/account_manager/account_manager.dart';

class WelcomeScreen extends StatelessWidget {
  final AccountManager accountManager = AccountManager();
  WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00B3A1),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 24.0),
                child: Column(
                  children: [
                    Text(
                      '75 Student',
                      style: TextStyle(
                        fontFamily: 'KdamThmorPro',
                        fontSize: 36,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 55),
                    Image(
                      image: AssetImage('assets/images/logo75.png'),
                      width: 250,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LogInScreen(
                              accountManager: accountManager,
                            )),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: const SizedBox(
                  width: 75,
                  height: 30,
                  child: Center(
                    child: Text(
                      'Log In',
                      style: TextStyle(
                        fontFamily: 'KdamThmorPro',
                        color: Color(0xFF00B3A1),
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SignUpScreen(
                              accountManager: accountManager,
                            )),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: const SizedBox(
                  width: 75,
                  height: 30,
                  child: Center(
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontFamily: 'KdamThmorPro',
                        color: Color(0xFF00B3A1),
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

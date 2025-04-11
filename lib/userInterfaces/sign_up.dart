import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:student_75/Components/account_manager/account_manager.dart';
import 'package:student_75/models/user_account_model.dart';
import 'package:student_75/userInterfaces/start_up.dart';
import 'package:student_75/userInterfaces/log_in.dart';
import 'package:student_75/userInterfaces/difficulty_page.dart';

class SignUpScreen extends StatefulWidget {
  final AccountManager accountManager;
  const SignUpScreen({super.key, required this.accountManager});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileEmailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String _selectedCountryCode = '+44'; // UK default
  final List<Map<String, String>> _countryData = [
    {'code': '+1', 'flag': '🇺🇸'},
    {'code': '+44', 'flag': '🇬🇧'},
    {'code': '+1', 'flag': '🇨🇦'},
    {'code': '+966', 'flag': '🇸🇦'},
    {'code': '+974', 'flag': '🇶🇦'},
    {'code': '+61', 'flag': '🇦🇺'},
    {'code': '+33', 'flag': '🇫🇷'},
    {'code': '+353', 'flag': '🇮🇪'},
  ];
  String _selectedInputType = 'Email'; // other variable

  @override
  Widget build(BuildContext context) {
    const Color teal = Color(0xFF00B3A1);
    const Color background = Color(0xFFE6F7F6);

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back arrow
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF00A59B)),
                  iconSize: 28,
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => WelcomeScreen()),
                  ),
                ),
                const SizedBox(height: 24),

                //75 student
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

                // Sign Up
                const Center(
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                        fontFamily: 'KdamThmorPro', fontSize: 24, color: Color(0xFF00B3A1)),
                  ),
                ),
                const SizedBox(height: 32),

                // Mobile/Email Input
                Row(
                  children: [
                    GestureDetector(
                      onTap: _showInputTypePicker,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBEFF0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Text(_selectedInputType),
                            const SizedBox(width: 6),
                            const Icon(CupertinoIcons.chevron_down, size: 16),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (_selectedInputType == 'Mobile') ...[
                      GestureDetector(
                        onTap: _showCountryPicker,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEBEFF0),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Text(
                                '${_countryData.firstWhere((c) => c['code'] == _selectedCountryCode)['flag']} $_selectedCountryCode',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(width: 6),
                              const Icon(CupertinoIcons.chevron_down, size: 16),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: _mobileEmailController,
                          decoration: InputDecoration(
                            hintText: _selectedInputType == 'Email' ? 'Email' : 'Mobile',
                            filled: true,
                            fillColor: const Color(0xFFEBEFF0),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (_selectedInputType == 'Email') {
                              if (value == null ||
                                  value.isEmpty ||
                                  !(value.contains('@') && value.contains('.'))) {
                                return 'Enter a valid email';
                              }
                            } else {
                              if (value == null || value.isEmpty) {
                                return 'Enter a valid mobile number';
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                // Full Name Input
                Container(
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: _fullNameController,
                    decoration: InputDecoration(
                      hintText: 'Full Name',
                      filled: true,
                      fillColor: const Color(0xFFEBEFF0),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.split(' ').length < 2) {
                        return 'Enter your Full Name';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 25),

                // Username Input
                Container(
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'Username',
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
                const SizedBox(height: 25),

                // Password Input
                Container(
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
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
                const SizedBox(height: 25),

                // Confirm Password Input
                Container(
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      filled: true,
                      fillColor: const Color(0xFFEBEFF0),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Already have an account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? ", style: TextStyle(color: Colors.grey)),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LogInScreen(
                                  accountManager: super.widget.accountManager,
                                )),
                      ),
                      child: const Text(
                        "Log in",
                        style: TextStyle(
                          color: teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Complete Sign Up Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DifficultyPage(
                                    signUpFlowState: UserAccountModel(
                                        id: 0,
                                        username: "testUser",
                                        difficulty: null,
                                        categoryOrder: null,
                                        sleepDuration: null,
                                        bedtimes: null,
                                        bedtimeNotifyBefore: null),
                                    accountManager: super.widget.accountManager,
                                  )),
                        );
                      }
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
                        "Complete Sign Up",
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

  void _showInputTypePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Select Input Type'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              setState(() => _selectedInputType = 'Email');
              Navigator.pop(context);
            },
            child: const Text('Email'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              setState(() => _selectedInputType = 'Mobile');
              Navigator.pop(context);
            },
            child: const Text('Mobile'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  void _showCountryPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Select Country Code'),
        actions: _countryData.map((country) {
          return CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                _selectedCountryCode = country['code']!;
              });
              Navigator.pop(context);
            },
            child: Text('${country['flag']} ${country['code']}'),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }
}

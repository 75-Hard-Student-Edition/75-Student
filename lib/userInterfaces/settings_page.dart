import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:student_75/Components/account_manager/account_manager.dart';
import 'package:student_75/models/difficulty_enum.dart';
import 'package:student_75/models/task_model.dart';
import 'package:student_75/userInterfaces/mindfulness_page.dart';
import 'package:student_75/userInterfaces/notifications_page.dart';
import 'package:student_75/userInterfaces/start_up.dart';
import 'package:student_75/userInterfaces/home.dart';
import 'package:student_75/userInterfaces/profile.dart';

class SettingsPage extends StatelessWidget {
  final AccountManager accountManager;

  const SettingsPage({
    super.key,
    required this.accountManager,
  });

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    double topPadding = MediaQuery.of(context).padding.top;
    Difficulty difficulty = accountManager.getDifficulty();
    TaskCategory topCategory = accountManager.getCategoryOrder().first;

    return Scaffold(
      backgroundColor: const Color(0xFFE6F4F3),
      bottomNavigationBar: CustomBottomNavBar(accountManager: accountManager),
      body: Padding(
        padding: EdgeInsets.only(top: topPadding + 2, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF00A59B), size: 30),
                  onPressed: () => Navigator.pop(context),
                  color: Colors.black87,
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      "Settings",
                      style: TextStyle(
                        fontFamily: 'kdamThmorPro',
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00B3A1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFEBEFF0),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2))
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Color(0xFFAFA9A9)),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildSettingItem(context, Icons.person, "Account", difficulty, topCategory),
            _buildSettingItem(
                context, Icons.notifications, "Notifications", difficulty, topCategory),
            _buildSettingItem(context, Icons.remove_red_eye, "Appearance", difficulty, topCategory),
            _buildSettingItem(
                context, Icons.accessibility_new, "Accessibility", difficulty, topCategory),
            _buildSettingItem(
                context, Icons.mail_outline, "Invite Friends", difficulty, topCategory),
            _buildSettingItem(context, Icons.lightbulb_outline, "Help", difficulty, topCategory),
            const SizedBox(height: 16),
            Center(
              child: TextButton.icon(
                onPressed: () {
                  showCupertinoDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoAlertDialog(
                        title: const Text("Log Out"),
                        content: const Text("Are you sure you want to log out?"),
                        actions: [
                          CupertinoDialogAction(
                            child: const Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          CupertinoDialogAction(
                            isDestructiveAction: true,
                            child: const Text("Yes"),
                            onPressed: () {
                              accountManager.logout();
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => WelcomeScreen()),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.block, color: Colors.red),
                label: const Text(
                  "Log Out",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'kdamThmorPro',
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, IconData icon, String title, Difficulty difficulty,
      TaskCategory topCategory) {
    return Column(
      children: [
        ListTile(
          leading: Icon(
            icon,
            size: 30,
            color: Colors.white,
            shadows: const [
              Shadow(
                offset: Offset(0, 4),
                blurRadius: 8,
                color: Color(0x3D000000),
              ),
            ],
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontFamily: 'kdamThmorPro',
              fontSize: 35,
              color: Color(0xFF787878),
              fontWeight: FontWeight.w400,
            ),
          ),
          onTap: () {
            if (title == "Notifications") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationScreen(
                    accountManager: accountManager,
                  ),
                ),
              );
            } else {
              print('$title tapped');
            }
          },
        ),
        const Padding(
          padding: EdgeInsets.only(top: 5),
          child: Divider(thickness: 1, height: 0),
        ),
      ],
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final AccountManager accountManager;
  const CustomBottomNavBar({
    super.key,
    required this.accountManager,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        BottomAppBar(
          color: const Color(0xFF00B3A1),
          shape: const CircularNotchedRectangle(),
          notchMargin: 6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home, color: Colors.white, size: 25),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ScheduleScreen(
                              accountManager: accountManager,
                            )),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.person, color: Colors.white, size: 25),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                              accountManager: accountManager,
                            )),
                  );
                },
              ),
              const SizedBox(width: 40),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white, size: 25),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ScheduleScreen(
                              accountManager: accountManager,
                            )),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.blur_on, color: Colors.white, size: 25),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MindfulnessScreen(
                        accountManager: accountManager,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 50,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationScreen(
                    accountManager: accountManager,
                  ),
                ),
              );
            },
            backgroundColor: Colors.white,
            elevation: 4,
            shape: const CircleBorder(),
            child: const Icon(
              Icons.settings,
              color: Color(0xFF00B3A1),
              size: 40,
            ),
          ),
        ),
      ],
    );
  }
}

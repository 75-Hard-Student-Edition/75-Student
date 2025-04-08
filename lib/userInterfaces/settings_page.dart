import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:student_75/models/difficulty_enum.dart';
import 'package:student_75/models/task_model.dart';
import 'package:student_75/userInterfaces/mindfulness_page.dart';
import 'package:student_75/userInterfaces/start_up.dart';
import 'package:student_75/userInterfaces/home.dart';
import 'package:student_75/userInterfaces/profile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFE6F4F3),
      bottomNavigationBar: const CustomBottomNavBar(difficulty: Difficulty.easy, topCategory: TaskCategory.academic), // Example difficulty
      body: Padding(
        padding: EdgeInsets.only(top: topPadding + 10, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, size: 30),
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
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2))
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
            _buildSettingItem(Icons.person, "Account"),
            _buildSettingItem(Icons.notifications, "Notifications"),
            _buildSettingItem(Icons.remove_red_eye, "Appearance"),
            _buildSettingItem(Icons.accessibility_new, "Accessibility"),
            _buildSettingItem(Icons.mail_outline, "Invite Friends"),
            _buildSettingItem(Icons.lightbulb_outline, "Help"),
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
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
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

  Widget _buildSettingItem(IconData icon, String title) {
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
            print('$title tapped');
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
  final Difficulty difficulty;
  final TaskCategory topCategory;
  const CustomBottomNavBar({
    super.key,
    required this.difficulty,
    required this.topCategory,
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
                    MaterialPageRoute(builder: (context) => ScheduleScreen(difficulty: difficulty, topCategory: topCategory)),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.person, color: Colors.white, size: 25),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen(difficulty: difficulty, topCategory: topCategory)),
                  );
                },
              ),
              const SizedBox(width: 40), // space taken by FAB
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white, size: 25),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ScheduleScreen(difficulty: difficulty, topCategory: topCategory)),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.blur_on, color: Colors.white, size: 25),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MindfulnessScreen()),
                  );
                },
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 50,
          child: FloatingActionButton(
            onPressed: () {},
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

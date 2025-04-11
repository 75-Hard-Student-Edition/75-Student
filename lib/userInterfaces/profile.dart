import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:student_75/Components/account_manager/account_manager.dart';
import 'dart:ui';
import 'package:student_75/models/difficulty_enum.dart';
import 'package:student_75/models/task_model.dart';
import 'package:student_75/userInterfaces/mindfulness_page.dart';

class ProfileScreen extends StatelessWidget {
  final AccountManager accountManager;

  const ProfileScreen({
    super.key,
    required this.accountManager,
  });

  Color _getTaskColor(TaskCategory category) {
    switch (category) {
      case TaskCategory.academic:
        return const Color(0xFF81E4F0);
      case TaskCategory.social:
        return const Color(0xFF8AD483);
      case TaskCategory.health:
        return const Color(0xFFF67373);
      case TaskCategory.employment:
        return const Color(0xFFEDBF45);
      case TaskCategory.chore:
        return const Color(0xFFE997CD);
      case TaskCategory.hobby:
        return const Color(0xFF946AAE);
    }
  }

  Widget _buildCircle({required double offsetX, required double offsetY}) {
    return Positioned(
      left: 50 + offsetX - 25,
      top: 50 + offsetY - 25,
      child: Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
          color: Color(0x7F00C69B),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
      child: Container(
        color: const Color(0xFFDCF0EE),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Back Button
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(height: 5),

                // My Profile Title
                const Text(
                  "My Profile",
                  style: TextStyle(
                    fontFamily: 'kdamThmorPro',
                    fontSize: 35,
                    color: Color(0xFF00B3A1),
                  ),
                ),
                const SizedBox(height: 20),

                // Profile Image
                GestureDetector(
                  onTap: () {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoActionSheet(
                          title: const Text("Profile Picture"),
                          message: const Text("Choose an option"),
                          actions: [
                            CupertinoActionSheetAction(
                              child: const Text("Upload Image"),
                              onPressed: () {
                                Navigator.pop(context);
                                // TODO: handle image upload
                              },
                            ),
                            CupertinoActionSheetAction(
                              isDestructiveAction: true,
                              onPressed: () {
                                Navigator.pop(context);
                                // TODO: handle image deletion
                              },
                              child: const Text("Delete Image"),
                            ),
                          ],
                          cancelButton: CupertinoActionSheetAction(
                            child: const Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      type: MaterialType.circle,
                      elevation: 2,
                      color: Colors.white,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.transparent,
                        backgroundImage: const AssetImage('assets/images/pfp.png'),
                        onBackgroundImageError: (exception, stackTrace) {
                          debugPrint('ERROR LOADING PROFILE IMAGE: $exception');
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Highest Point of Priority
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "HIGHEST POINT OF PRIORITY: ",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF999696),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'kdamThmorPro',
                      ),
                    ),
                    Text(
                      accountManager.getCategoryOrder().first.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 16,
                        color: _getTaskColor(accountManager.getCategoryOrder().first),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'kdamThmorPro',
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),

                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Mindfulness stuff
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: accountManager.getDifficulty() == Difficulty.easy
                            ? Colors.green
                            : accountManager.getDifficulty() == Difficulty.medium
                                ? Colors.orange
                                : Colors.redAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        accountManager.getDifficulty().name.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontFamily: 'kdamThmorPro',
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MindfulnessScreen(
                              accountManager: accountManager,
                            ),
                          ),
                        );
                      },
                      child: Center(
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: Stack(
                            children: [
                              _buildCircle(offsetX: 0, offsetY: -20),
                              _buildCircle(offsetX: 15, offsetY: -15),
                              _buildCircle(offsetX: 20, offsetY: 0),
                              _buildCircle(offsetX: 15, offsetY: 15),
                              _buildCircle(offsetX: 0, offsetY: 20),
                              _buildCircle(offsetX: -15, offsetY: 15),
                              _buildCircle(offsetX: -20, offsetY: 0),
                              _buildCircle(offsetX: -15, offsetY: -15),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.play_arrow, color: Colors.teal, size: 28),
                    const Icon(Icons.pause, color: Colors.teal, size: 28),
                  ],
                ),
                const SizedBox(height: 40),

                // Badges
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.teal, width: 3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Badges",
                          style: TextStyle(
                              fontSize: 22, color: Colors.grey, fontFamily: 'kdamThmorPro')),
                      const SizedBox(height: 16),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 14,
                        runSpacing: 14,
                        children: List.generate(6, (index) {
                          return Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('assets/images/badge_${index + 1}.jpg'),
                              ),
                              border: Border.all(color: Colors.amber, width: 2.5),
                            ),
                          );
                        }),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

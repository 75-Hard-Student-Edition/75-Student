import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xE0E6F4F3),
      bottomNavigationBar: CustomBottomNavBar(),
      body: Padding(
        padding: EdgeInsets.only(top: topPadding + 10, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () => Navigator.pop(context),
                  color: Colors.black87,
                ),
                const SizedBox(width: 8),
                Text(
                  "Settings",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
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
                  hintText: "search...",
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
                onPressed: () {},
                icon: const Icon(Icons.block, color: Colors.red),
                label: const Text(
                  "Log Out",
                  style: TextStyle(color: Colors.red, fontSize: 16),
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
          leading: Icon(icon, color: Colors.black54),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            print('$title tapped');
          },
        ),
        const Divider(thickness: 1, height: 0),
      ],
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.teal,
      shape: const CircularNotchedRectangle(),
      notchMargin: 6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
              icon: const Icon(Icons.home, color: Colors.white), onPressed: () {}),
          IconButton(
              icon: const Icon(Icons.person, color: Colors.white), onPressed: () {}),
          const SizedBox(width: 40), // Space for center button
          IconButton(
              icon: const Icon(Icons.add, color: Colors.white), onPressed: () {}),
          IconButton(
              icon: const Icon(Icons.blur_on, color: Colors.white), onPressed: () {}),
        ],
      ),
    );
  }
}

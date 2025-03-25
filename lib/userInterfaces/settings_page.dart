import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Color(0xE0E6F4F3),
      bottomNavigationBar: CustomBottomNavBar(),
      body: Padding(
        padding: EdgeInsets.only(top: topPadding + 10, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () => Navigator.pop(context),
                  color: Colors.black87,
                ),
                SizedBox(width: 8),
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
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2))
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "search...",
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 16),
            _buildSettingItem(Icons.person, "Account"),
            _buildSettingItem(Icons.notifications, "Notifications"),
            _buildSettingItem(Icons.remove_red_eye, "Appearance"),
            _buildSettingItem(Icons.accessibility_new, "Accessibility"),
            _buildSettingItem(Icons.mail_outline, "Invite Friends"),
            _buildSettingItem(Icons.lightbulb_outline, "Help"),
            SizedBox(height: 16),
            Center(
              child: TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.block, color: Colors.red),
                label: Text(
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
            style: TextStyle(
              fontSize: 18,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            print('$title tapped');
          },
        ),
        Divider(thickness: 1, height: 0),
      ],
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.teal,
      shape: CircularNotchedRectangle(),
      notchMargin: 6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
              icon: Icon(Icons.home, color: Colors.white), onPressed: () {}),
          IconButton(
              icon: Icon(Icons.person, color: Colors.white), onPressed: () {}),
          SizedBox(width: 40), // Space for center button
          IconButton(
              icon: Icon(Icons.add, color: Colors.white), onPressed: () {}),
          IconButton(
              icon: Icon(Icons.blur_on, color: Colors.white), onPressed: () {}),
        ],
      ),
    );
  }
}

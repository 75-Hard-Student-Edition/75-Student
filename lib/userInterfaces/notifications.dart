<<<<<<< HEAD
// test
=======
import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool announceNotifications = false;
  bool showPrevious = true;
  bool snooze = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildNotificationSettings(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, size: 28),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Spacer(),
          Text(
            "Notifications",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDropdown("Set Notifications", [
                "None",
                "15 minutes before",
                "30 minutes before",
                "When the task starts",
                "When the task ends"
              ]),
              SizedBox(height: 20),
              _buildTimePicker("Set Reminders", "Wind down time reminder"),
              SizedBox(height: 20),
              _buildToggleOption(
                  "Announce Notifications", announceNotifications, (value) {
                setState(() {
                  announceNotifications = value;
                });
              }),
              SizedBox(height: 10),
              _buildToggleOption("Show Previous", showPrevious, (value) {
                setState(() {
                  showPrevious = value;
                });
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String title, List<String> options) {
    String selectedOption = options[0];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField(
          decoration: InputDecoration(border: OutlineInputBorder()),
          value: selectedOption,
          items: options.map((String option) {
            return DropdownMenuItem(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedOption = value.toString();
            });
          },
        ),
      ],
    );
  }

  Widget _buildTimePicker(String title, String subtitle) {
    TimeOfDay selectedTime = TimeOfDay(hour: 9, minute: 15);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: selectedTime,
            );
            if (pickedTime != null) {
              setState(() {
                selectedTime = pickedTime;
              });
            }
          },
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${selectedTime.hour}:${selectedTime.minute} ${selectedTime.period == DayPeriod.am ? "AM" : "PM"}",
                  style: TextStyle(fontSize: 16),
                ),
                Icon(Icons.access_time),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleOption(
      String title, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 16)),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
>>>>>>> notifications-page

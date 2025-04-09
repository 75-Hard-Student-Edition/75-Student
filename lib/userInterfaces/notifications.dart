import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool announceNotifications = false;
  bool showPrevious = true;
  bool snooze = true;
  DateTime selectedNotificationTime = DateTime.now();
  DateTime selectedWindDownTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F2F0),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildAlwaysVisibleNotificationWindow(),
            _buildNotificationSettings(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, size: 28, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const Spacer(),
          const Text(
            "Notifications",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF248F84)),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildAlwaysVisibleNotificationWindow() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Current Notification Settings",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF248F84))),
          const SizedBox(height: 10),
          Text(
              "Notification Time: ${selectedNotificationTime.hour}:${selectedNotificationTime.minute} ${selectedNotificationTime.hour < 12 ? "AM" : "PM"}",
              style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 5),
          Text(
              "Wind Down Time: ${selectedWindDownTime.hour}:${selectedWindDownTime.minute} ${selectedWindDownTime.hour < 12 ? "AM" : "PM"}",
              style: const TextStyle(fontSize: 16)),
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
              const SizedBox(height: 20),
              _buildCupertinoTimePicker("Set Reminders"),
              const SizedBox(height: 20),
              _buildToggleOption(
                  "Announce Notifications", announceNotifications, (value) {
                setState(() {
                  announceNotifications = value;
                });
              }),
              const SizedBox(height: 10),
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
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF248F84)),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField(
          decoration: const InputDecoration(border: OutlineInputBorder()),
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

  Widget _buildCupertinoTimePicker(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF248F84)),
        ),
        const SizedBox(height: 8),
        CupertinoButton(
          child: const Text("Select Time"),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext builder) {
                return Container(
                  height: 250,
                  color: Colors.white,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime: selectedWindDownTime,
                    onDateTimeChanged: (DateTime newTime) {
                      setState(() {
                        selectedWindDownTime = newTime;
                      });
                    },
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildToggleOption(
      String title, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, color: Color(0xFF248F84))),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF248F84),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

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
      backgroundColor: Color(0xFFE6F2F0),
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
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, size: 28, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Spacer(),
          Text(
            "Notifications",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF248F84)),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget _buildAlwaysVisibleNotificationWindow() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(16),
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
          Text("Current Notification Settings",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF248F84))),
          SizedBox(height: 10),
          Text(
              "Notification Time: ${selectedNotificationTime.hour}:${selectedNotificationTime.minute} ${selectedNotificationTime.hour < 12 ? "AM" : "PM"}",
              style: TextStyle(fontSize: 16)),
          SizedBox(height: 5),
          Text(
              "Wind Down Time: ${selectedWindDownTime.hour}:${selectedWindDownTime.minute} ${selectedWindDownTime.hour < 12 ? "AM" : "PM"}",
              style: TextStyle(fontSize: 16)),
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
              _buildCupertinoTimePicker("Set Reminders"),
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
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF248F84)),
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

  Widget _buildCupertinoTimePicker(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF248F84)),
        ),
        SizedBox(height: 8),
        CupertinoButton(
          child: Text("Select Time"),
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
        Text(title, style: TextStyle(fontSize: 16, color: Color(0xFF248F84))),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Color(0xFF248F84),
        ),
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_75/models/difficulty_enum.dart';
import 'package:student_75/userInterfaces/home.dart';
import 'package:student_75/models/task_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String notificationType = 'Before Task';
  String? selectedBeforeTime;
  TimeOfDay selectedWindDownTime = const TimeOfDay(hour: 21, minute: 0);
  int mindfulnessDuration = 30;
  bool allowSnooze = false;
  bool notificationsEnabled = true;

  final List<String> beforeTaskOptions = [
    '5 minutes',
    '10 minutes',
    '15 minutes',
    '30 minutes',
    '45 minutes',
    '1 hour',
  ];

  final List<int> mindfulnessDurations = [
    30,
    45,
    60,
    75,
    90,
    105,
    120,
  ];

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedWindDownTime,
    );
    if (picked != null && picked != selectedWindDownTime) {
      setState(() {
        selectedWindDownTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFEAF7F7),
        bottomNavigationBar: const CustomBottomNavBar(
            difficulty: Difficulty.easy, topCategory: TaskCategory.academic),
        body: SafeArea(
            child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 160),
                child: Column(children: [
                            Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.of(context).pop(),
                child: const Icon(Icons.arrow_back_ios, color: Color(0xFF00A59B)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Notifications',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00A59B),
              fontFamily: 'KdamThmorPro',
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Enable Notifications',
                  style: TextStyle(fontFamily: 'KdamThmorPro')),
              const SizedBox(width: 10),
              CupertinoSwitch(
                value: notificationsEnabled,
                onChanged: (bool value) {
                  setState(() {
                    notificationsEnabled = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          IgnorePointer(
            ignoring: !notificationsEnabled,
            child: Opacity(
              opacity: notificationsEnabled ? 1.0 : 0.4,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.notifications,
                            size: 20, color: Color(0xFF6E6E6E)),
                        SizedBox(width: 10),
                        Text(
                          'Task Notifications',
                          style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF6E6E6E),
                              fontFamily: 'KdamThmorPro'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Toggle between Before Task and Start of Task

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Before Task Column
                      Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: ChoiceChip(
                              label: const Text('Before Task',
                                  style: TextStyle(fontFamily: 'KdamThmorPro')),
                              selected: notificationType == 'Before Task',
                              onSelected: (_) {
                                setState(() {
                                  notificationType = 'Before Task';
                                });
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.info_outline, size: 16),
                            onPressed: () {
                              showCupertinoDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CupertinoAlertDialog(
                                    title: const Text('Before Task'),
                                    content: const Text(
                                        'This notification will remind you before starting the task.'),
                                    actions: <Widget>[
                                      CupertinoDialogAction(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),

                      const SizedBox(width: 10),

                      // Start of Task Column
                      Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: ChoiceChip(
                              label: const Text('Start of Task',
                                  style: TextStyle(fontFamily: 'KdamThmorPro')),
                              selected: notificationType == 'Start of Task',
                              onSelected: (_) {
                                setState(() {
                                  notificationType = 'Start of Task';
                                });
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.info_outline, size: 16),
                            onPressed: () {
                              showCupertinoDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CupertinoAlertDialog(
                                    title: const Text('Start of Task'),
                                    content: const Text(
                                        'This notification will remind you when the task starts.'),
                                    actions: <Widget>[
                                      CupertinoDialogAction(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),

                  if (notificationType == 'Before Task') ...[
                    const SizedBox(height: 5),
                    const Text('Select reminder time:',
                        style: TextStyle(fontFamily: 'KdamThmorPro')),
                    const SizedBox(height: 5),
                    Container(
                      height: 100,
                      width: 200,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF7F7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CupertinoPicker(
                        backgroundColor: Colors.transparent,
                        itemExtent: 32.0,
                        scrollController: FixedExtentScrollController(
                          initialItem: selectedBeforeTime != null
                              ? beforeTaskOptions.indexOf(selectedBeforeTime!)
                              : 0,
                        ),
                        onSelectedItemChanged: (int index) {
                          setState(() {
                            selectedBeforeTime = beforeTaskOptions[index];
                          });
                        },
                        children: beforeTaskOptions
                            .map((option) => Center(
                                  child: Text(
                                    option,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ],

                  const SizedBox(height: 30),
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.access_alarm,
                            size: 20, color: Color(0xFF6E6E6E)),
                        SizedBox(width: 10),
                        Text(
                          'Set Reminders',
                          style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF6E6E6E),
                              fontFamily: 'KdamThmorPro'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('WIND DOWN',
                              style: TextStyle(
                                  fontFamily: 'KdamThmorPro', fontSize: 16)),
                          Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: CupertinoButton(
                              child: Text(
                                selectedWindDownTime.format(context),
                                style: const TextStyle(
                                  color: Color(0xFF00B3A1),
                                  fontFamily: 'KdamThmorPro',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                TimeOfDay tempSelectedTime =
                                    selectedWindDownTime;
                                bool tempSnooze = allowSnooze;

                                showCupertinoModalPopup(
                                  context: context,
                                  builder: (_) => StatefulBuilder(
                                    builder: (context, setModalState) {
                                      return Container(
                                        height: 300,
                                        color: Colors.white,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  CupertinoButton(
                                                    padding: EdgeInsets.zero,
                                                    child: const Text('Cancel'),
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(),
                                                  ),
                                                  CupertinoButton(
                                                    padding: EdgeInsets.zero,
                                                    child: const Text('Save'),
                                                    onPressed: () {
                                                      setState(() {
                                                        selectedWindDownTime =
                                                            tempSelectedTime;
                                                        allowSnooze =
                                                            tempSnooze;
                                                      });
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 150,
                                              child: CupertinoDatePicker(
                                                mode: CupertinoDatePickerMode
                                                    .time,
                                                use24hFormat: false,
                                                initialDateTime: DateTime(
                                                  2025,
                                                  1,
                                                  1,
                                                  selectedWindDownTime.hour,
                                                  selectedWindDownTime.minute,
                                                ),
                                                onDateTimeChanged:
                                                    (DateTime newDateTime) {
                                                  setModalState(() {
                                                    tempSelectedTime =
                                                        TimeOfDay(
                                                      hour: newDateTime.hour,
                                                      minute:
                                                          newDateTime.minute,
                                                    );
                                                  });
                                                },
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const SizedBox(width: 16),
                                                const Text(
                                                  'Snooze',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontFamily: 'KdamThmorPro',
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                CupertinoSwitch(
                                                  value: tempSnooze,
                                                  onChanged: (bool value) {
                                                    setModalState(() {
                                                      tempSnooze = value;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ]),
                  ),

                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'MINDFULNESS',
                          style: TextStyle(
                              fontSize: 16, fontFamily: 'KdamThmorPro'),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 4),
                          child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: Text(
                              mindfulnessDuration >= 60
                                  ? '${mindfulnessDuration ~/ 60}h ${mindfulnessDuration % 60}min'
                                  : '$mindfulnessDuration min',
                              style: const TextStyle(
                                color: Color(0xFF00B3A1),
                                fontFamily: 'KdamThmorPro',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              int tempDuration = mindfulnessDuration;

                              showCupertinoModalPopup(
                                context: context,
                                builder: (_) => Container(
                                  height: 300,
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CupertinoButton(
                                              padding: EdgeInsets.zero,
                                              child: const Text('Cancel'),
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                            ),
                                            CupertinoButton(
                                              padding: EdgeInsets.zero,
                                              child: const Text('Save'),
                                              onPressed: () {
                                                setState(() {
                                                  mindfulnessDuration =
                                                      tempDuration;
                                                });
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: CupertinoPicker(
                                          scrollController:
                                              FixedExtentScrollController(
                                            initialItem: mindfulnessDurations
                                                .indexOf(mindfulnessDuration),
                                          ),
                                          itemExtent: 32.0,
                                          onSelectedItemChanged: (index) {
                                            tempDuration =
                                                mindfulnessDurations[index];
                                          },
                                          children: mindfulnessDurations
                                              .map((duration) => Center(
                                                    child: Text(
                                                      duration >= 60
                                                          ? '${duration ~/ 60}h ${duration % 60}min'
                                                          : '$duration min',
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              'KdamThmorPro'),
                                                    ),
                                                  ))
                                              .toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]))));
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
    return Padding(
    padding: const EdgeInsets.only(bottom: 25),
    child: Column(
      mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00A59B),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            ),
            onPressed: () {
              showCupertinoDialog(
                context: context,
                builder: (BuildContext context) {
                  return CupertinoAlertDialog(
                    title: const Text('Save Settings'),
                    content: const Text('Are you sure you want to save your notification preferences?'),
                    actions: [
                      CupertinoDialogAction(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      CupertinoDialogAction(
                        isDefaultAction: true,
                        child: const Text('Save'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text('Save',
                style: TextStyle(fontFamily: 'KdamThmorPro')),
          ),
          const SizedBox(height: 10),
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 30,
            child: IconButton(
              icon: const Icon(Icons.home, color: Color(0xFF00A59B)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ScheduleScreen(
                          difficulty: difficulty, topCategory: topCategory)),
                );
              },
            ),
          ),
        ],
      ));
  }
}

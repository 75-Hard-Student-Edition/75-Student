import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_75/Components/account_manager/account_manager.dart';
import 'package:student_75/userInterfaces/home.dart';

class NotificationScreen extends StatefulWidget {
  final AccountManager accountManager;
  const NotificationScreen({super.key, required this.accountManager});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String notificationType = 'Before Task';
  String? selectedBeforeTime;
  late TimeOfDay selectedWindDownTime;
  late int mindfulnessDuration;
  bool allowSnooze = false;
  bool notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    selectedWindDownTime = widget.accountManager.getBedtime();
    mindfulnessDuration = widget.accountManager.getMindfulnessDuration().inMinutes;
  }

  final Map<String, Duration> beforeTaskOptionsMap = {
    '5 minutes': const Duration(minutes: 5),
    '10 minutes': const Duration(minutes: 10),
    '15 minutes': const Duration(minutes: 15),
    '30 minutes': const Duration(minutes: 30),
    '45 minutes': const Duration(minutes: 45),
    '1 hour': const Duration(hours: 1),
  };

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
        bottomNavigationBar: CustomBottomNavBar(accountManager: widget.accountManager),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(children: [
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF00A59B), size: 30),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Center(
                      child: Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00A59B),
                          fontFamily: 'KdamThmorPro',
                        ),
                      ),
                      ),
                    ],
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
                                Icon(Icons.notifications, size: 20, color: Color(0xFF6E6E6E)),
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
                                  //! This is meant to be taskNotifyBefore time - rearranging of how it works needed
                                  // widget.accountManager.updateAccount(
                                  //   widget.accountManager.userAccount!.copyWith(
                                  //     bedtimeNotifyBefore:
                                  //         beforeTaskOptionsMap[beforeTaskOptions[index]]!,
                                  //   ),
                                  // );
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
                                Icon(Icons.access_alarm, size: 20, color: Color(0xFF6E6E6E)),
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
                            child:
                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              const Text('WIND DOWN',
                                  style: TextStyle(fontFamily: 'KdamThmorPro', fontSize: 16)),
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
                                    TimeOfDay tempSelectedTime = selectedWindDownTime;
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
                                                            selectedWindDownTime = tempSelectedTime;
                                                            allowSnooze = tempSnooze;
                                                          });
                                                          widget.accountManager.updateAccount(widget
                                                              .accountManager.userAccount!
                                                              .copyWith(
                                                            bedtimeNotifyBefore: Duration.zero,
                                                            bedtime: selectedWindDownTime,
                                                          ));
                                                          Navigator.of(context).pop();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 150,
                                                  child: CupertinoDatePicker(
                                                    mode: CupertinoDatePickerMode.time,
                                                    use24hFormat: false,
                                                    initialDateTime: DateTime(
                                                      2025,
                                                      1,
                                                      1,
                                                      selectedWindDownTime.hour,
                                                      selectedWindDownTime.minute,
                                                    ),
                                                    onDateTimeChanged: (DateTime newDateTime) {
                                                      setModalState(() {
                                                        tempSelectedTime = TimeOfDay(
                                                          hour: newDateTime.hour,
                                                          minute: newDateTime.minute,
                                                        );
                                                      });
                                                    },
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                  style: TextStyle(fontSize: 16, fontFamily: 'KdamThmorPro'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 4),
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
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    CupertinoButton(
                                                      padding: EdgeInsets.zero,
                                                      child: const Text('Cancel'),
                                                      onPressed: () => Navigator.of(context).pop(),
                                                    ),
                                                    CupertinoButton(
                                                      padding: EdgeInsets.zero,
                                                      child: const Text('Save'),
                                                      onPressed: () {
                                                        setState(() {
                                                          mindfulnessDuration = tempDuration;
                                                        });
                                                        widget.accountManager.updateAccount(
                                                          widget.accountManager.userAccount!
                                                              .copyWith(
                                                            mindfulnessDuration: Duration(
                                                                minutes: mindfulnessDuration),
                                                          ),
                                                        );
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: CupertinoPicker(
                                                  scrollController: FixedExtentScrollController(
                                                    initialItem: mindfulnessDurations
                                                        .indexOf(mindfulnessDuration),
                                                  ),
                                                  itemExtent: 32.0,
                                                  onSelectedItemChanged: (index) {
                                                    tempDuration = mindfulnessDurations[index];
                                                  },
                                                  children: mindfulnessDurations
                                                      .map((duration) => Center(
                                                            child: Text(
                                                              duration >= 60
                                                                  ? '${duration ~/ 60}h ${duration % 60}min'
                                                                  : '$duration min',
                                                              style: const TextStyle(
                                                                  fontFamily: 'KdamThmorPro'),
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
  final AccountManager accountManager;

  const CustomBottomNavBar({
    super.key,
    required this.accountManager,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
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
                  title: const Text('Save Settings?'),
                  content:
                      const Text('Are you sure you want to save your notification preferences?'),
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
          child: const Text('Save', style: TextStyle(fontFamily: 'KdamThmorPro')),
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
                          accountManager: accountManager,
                        )),
              ); 
            },
          ),
        ),
        ],
      ),
    );
  }
}
  
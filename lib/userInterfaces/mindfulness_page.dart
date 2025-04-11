import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:student_75/models/difficulty_enum.dart';
import 'package:student_75/models/task_model.dart';
import 'package:student_75/userInterfaces/home.dart';
import 'package:student_75/userInterfaces/profile.dart';
import 'package:student_75/userInterfaces/settings_page.dart';

class MindfulnessScreen extends StatefulWidget {
  final Difficulty difficulty;
  final TaskCategory topCategory;

  const MindfulnessScreen({
    super.key,
    required this.difficulty,
    required this.topCategory,
  });

  @override
  State<MindfulnessScreen> createState() => _MindfulnessScreenState();
}

class _MindfulnessScreenState extends State<MindfulnessScreen> with SingleTickerProviderStateMixin {

  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  Duration _duration = const Duration(minutes: 30);
  Timer? _timer;

  String get _formattedTime {
    final hours = _duration.inHours;
    final minutes = _duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = _duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return hours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }

  void _startTimer() {
    if (_timer != null && _timer!.isActive) return;
    _controller.repeat(reverse: true); 
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_duration.inSeconds > 0) {
        setState(() {
          _duration -= const Duration(seconds: 1);
        });
      } else {
        _stopTimer();
      }
    });
  }

  void _stopTimer() {
    _controller.stop();
    _timer?.cancel();
  }

  void _resetTimer() {
    _stopTimer();
    setState(() {
      _duration = const Duration(minutes: 30);
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    ); // don't start immediately

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFEAF7F7),
      bottomNavigationBar: CustomBottomNavBar(difficulty: widget.difficulty, topCategory: widget.topCategory,), 
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
            
            const Padding(
              padding: EdgeInsets.only(top: 0),
              child: Text(
                "Mindfulness",
                style: TextStyle(
                  fontFamily: 'KdamThmorPro',
                  fontSize: 35,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF00A59B),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // will change
            Center(
              child: SizedBox(
                width: 300,
                height: 300,
                child: AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Stack(
                        children: [
                          _buildCircle(offsetX: 0, offsetY: -60),
                          _buildCircle(offsetX: 45, offsetY: -45),
                          _buildCircle(offsetX: 60, offsetY: 0),
                          _buildCircle(offsetX: 45, offsetY: 45),
                          _buildCircle(offsetX: 0, offsetY: 60),
                          _buildCircle(offsetX: -45, offsetY: 45),
                          _buildCircle(offsetX: -60, offsetY: 0),
                          _buildCircle(offsetX: -45, offsetY: -45),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            GestureDetector(
              onTap: () async {
                if (_timer != null && _timer!.isActive) {
                  _resetTimer(); // automatically reset if timer is active
                }

                Duration selectedDuration = _duration;

                Duration? pickedDuration = await showModalBottomSheet<Duration>(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 300,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Expanded(
                            child: CupertinoTimerPicker(
                              mode: CupertinoTimerPickerMode.hm,
                              initialTimerDuration: selectedDuration,
                              minuteInterval: 15,
                              onTimerDurationChanged: (Duration newDuration) {
                                selectedDuration = newDuration;
                              },
                            ),
                          ),
                          CupertinoButton(
                            child: const Text('Done'),
                            onPressed: () {
                              if (selectedDuration >= const Duration(minutes: 30) &&
                                  selectedDuration <= const Duration(hours: 2)) {
                                Navigator.pop(context, selectedDuration);
                              } else if (selectedDuration > const Duration(hours: 2)) {
                                showCupertinoDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CupertinoAlertDialog(
                                      title: const Text("Invalid Duration"),
                                      content: const Text("2 hours max!"),
                                      actions: [
                                        CupertinoDialogAction(
                                          isDefaultAction: true,
                                          onPressed: () {
                                            Navigator.of(context).pop(); 
                                          },
                                          child: const Text("OK"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                Navigator.pop(context, null);
                              }
                            },
                          )
                        ],
                      ),
                    );
                  },
                );

                if (pickedDuration != null) {
                  setState(() {
                    _duration = pickedDuration;
                  });
                }
              },
              child: Text(
                _formattedTime,
                style: const TextStyle(
                  fontFamily: 'KdamThmorPro',
                  fontSize: 50,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF616161),
                ),
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              "breathe in, breathe out",
              style: TextStyle(
                fontFamily: 'KdamThmorPro',
                fontSize: 16,
                color: Color(0xFF757575),
              ),
            ),
          

            const SizedBox(height: 30),

          

            //  buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade300,
                    shadowColor: Colors.green,
                  ),
                  onPressed: _startTimer,
                  child: const Text(
                    "START",
                    style: TextStyle(
                      fontFamily: 'KdamThmorPro',
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade300,
                    shadowColor: Colors.red,
                  ),
                  onPressed: _stopTimer,
                  child: const Text(
                    "STOP",
                    style: TextStyle(
                      fontFamily: 'KdamThmorPro',
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
              onPressed: _resetTimer,
              child: const Text(
                "RESTART",
                style: TextStyle(
                  fontFamily: 'KdamThmorPro',
                  color: Color(0xFFFFFFFF),
                ),
              ),
            ),
          ],
        ),
      ),
      )
    );
  }

  Widget _buildCircle({required double offsetX, required double offsetY}) {
    return Positioned(
      left: 150 + offsetX - 50,
      top: 150 + offsetY - 50,
      child: Container(
        width: 130,
        height: 130,
        decoration: const BoxDecoration(
          color: Color(0x7F00C69B),
          shape: BoxShape.circle,
        ),
      ),
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
              const SizedBox(width: 40), 
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
                icon: const Icon(Icons.settings, color: Colors.white, size: 25),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsPage(
                        difficulty: difficulty,
                        topCategory: topCategory,
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
            onPressed: () {},
            backgroundColor: Colors.white,
            elevation: 4,
            shape: const CircleBorder(),
            child: const Icon(
              Icons.blur_on,
              color: Color(0xFF00B3A1),
              size: 40,
            ),
          ),
        ),
      ],
    );
  }
}

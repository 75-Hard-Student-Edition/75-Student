import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:student_75/models/difficulty_enum.dart';
import 'package:student_75/models/task_model.dart';
import 'package:student_75/userInterfaces/home.dart';
import 'package:student_75/userInterfaces/profile.dart';

class MindfulnessScreen extends StatefulWidget {
  const MindfulnessScreen({super.key});

  @override
  State<MindfulnessScreen> createState() => _MindfulnessScreenState();
}

class _MindfulnessScreenState extends State<MindfulnessScreen> with SingleTickerProviderStateMixin {

  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

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
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFEAF7F7),
      body: SafeArea(
        child: Column(
          children: [
            // static rn
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      const Icon(Icons.folder_open_outlined, size: 30),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Row(
                    children: [
                      Text(
                        "25",
                        style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.local_fire_department,
                          color: Colors.deepOrange),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Mindfulness",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF00A59B),
              ),
            ),

            const SizedBox(height: 30),

            // will change
            SizedBox(
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

            const SizedBox(height: 20),

            const Text(
              "30:00",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              "breathe in, breathe out",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
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
                  onPressed: () {},
                  child: const Text("START"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade300,
                    shadowColor: Colors.red,
                  ),
                  onPressed: () {},
                  child: const Text("STOP"),
                ),
              ],
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
              onPressed: () {},
              child: const Text("RESTART"),
            ),
          ],
        ),
      ),
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
                    MaterialPageRoute(
                        builder: (context) => ScheduleScreen(
                            difficulty: difficulty, topCategory: topCategory)),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.person, color: Colors.white, size: 25),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                            difficulty: difficulty, topCategory: topCategory)),
                  );
                },
              ),
              const SizedBox(width: 40), // space taken by FAB
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white, size: 25),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ScheduleScreen(
                            difficulty: difficulty, topCategory: topCategory)),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.blur_on, color: Colors.white, size: 25),
                onPressed: () {},
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

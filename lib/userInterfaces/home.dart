import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_75/models/task_model.dart'; // Correct TaskModel import
import 'package:student_75/Components/schedule_manager/schedule_manager.dart';
import 'package:student_75/Components/schedule_manager/schedule.dart';
import 'package:student_75/userInterfaces/add_task.dart';
import 'package:student_75/Components/account_manager/account_manager.dart';
import 'package:student_75/userInterfaces/settings_page.dart';
import 'package:student_75/userInterfaces/difficulty_page.dart';
import 'package:student_75/userInterfaces/profile.dart';
import 'package:student_75/models/difficulty_enum.dart';


class ScheduleScreen extends StatefulWidget {
  final TaskCategory topCategory;
  final Difficulty difficulty;
  
  const ScheduleScreen({
    super.key,
    required this.difficulty,
    required this.topCategory,
  });

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late final AccountManager accountManager;
  late final ScheduleManager scheduleManager;
  late Schedule displaySchedule; // Stores tasks

  @override
  void initState() {
    super.initState();
    accountManager = AccountManager();
    accountManager.login("username", "password"); //! Temporary test user
    scheduleManager = ScheduleManager(
      accountManager: accountManager,
      displayErrorCallback: (String message) {
        print("Error: $message"); // ✅ Handles the error properly
      },
    );
    displaySchedule = scheduleManager.schedule;
    //_addTask(newTask);
    _fetchSchedule();
  }

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

  /// Tasks from backend
  void _fetchSchedule() {
    setState(() {
      displaySchedule = scheduleManager.schedule;
    });
    print("Fetched schedule from backend: ${displaySchedule.length} tasks loaded.");
  }

  void _navigateToAddTaskScreen() async {
    final newTask = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTaskScreen(scheduleManager: scheduleManager)),
    );

    if (newTask != null && newTask is TaskModel) {
      setState(() {
        scheduleManager.addTask(newTask); 
        _fetchSchedule(); 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double topPadding = MediaQuery.of(context).padding.top;
    String currentDay = DateFormat('d').format(DateTime.now());
    String currentMonth = DateFormat('MMM').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavBar(
        scheduleManager: scheduleManager,
        refreshSchedule: _fetchSchedule, 
        difficulty: widget.difficulty,
        topCategory: widget.topCategory,
      ),
      body: Column(
        children: [
          SizedBox(height: topPadding + 10),
          _buildHeader(context, currentDay, currentMonth),
          _buildProgressBar(context),
          Expanded(
            child: SingleChildScrollView(
              child: _buildSchedule(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String day, String month) {
    double screenWidth = MediaQuery.of(context).size.width;
// Extra padding for iPhone 15 Pro

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Column(
        children: [
          // Date (Centered Below Dynamic Island)
          Column(
            children: [
              Text(
                day,
                style: TextStyle(fontSize: screenWidth * 0.12, fontWeight: FontWeight.bold),
              ),
              Text(
                month.toUpperCase(),
                style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700]),
              ),
            ],
          ),
          const SizedBox(height: 10), // Space for progress bar

          // Streak
          Align(
            alignment: Alignment.topRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.local_fire_department, color: Colors.orange, size: screenWidth * 0.06),
                Text(
                  "25", // Streak number
                  style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Schedule Grid (each line represents a time slot)
  Widget _buildSchedule(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 1200,
      child: Stack(
        children: [
          Column(
            children: List.generate(24, (index) {
              String hourText = index < 10 ? "0$index:00" : "$index:00";
              return Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade300, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: screenWidth * 0.12,
                      child: Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.02),
                        child: Text(
                          hourText,
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.black54, fontSize: screenWidth * 0.03),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          for (var task in scheduleManager.schedule.tasks) _buildDraggableTimeBlock(context, task),
        ],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
      child: Stack(
        children: [
          Container(
            height: 8,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Colors.red, Colors.orange, Colors.green]), //need to assign to categories
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Positioned(
            left: screenWidth * 0.4,
            child: Container(
              height: 16,
              width: 8,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Draggable & Resizable
  Widget _buildDraggableTimeBlock(BuildContext context, TaskModel task) {
    print("Rendering Task: ${task.name} at ${task.startTime}");

    double screenWidth = MediaQuery.of(context).size.width;
    double hourHeight = 50;

    Color taskColor = _getTaskColor(task.category);

    return Positioned(
      top: hourHeight * task.startTime.hour + (task.startTime.minute / 60) * hourHeight,
      left: screenWidth * 0.15,
      child: GestureDetector(
        // change start time
        onVerticalDragUpdate: task.isMovable
            ? (details) {
                setState(() {
                  DateTime newStart = task.startTime
                      .add(Duration(minutes: (details.primaryDelta! / hourHeight * 60).round()));

                  // Ensure new start time is valid
                  if (newStart.isBefore(task.endTime)) {
                    TaskModel updatedTask = task.copyWith(startTime: newStart);
                    scheduleManager.editTask(updatedTask);
                    print("Moved Task: '${task.name}' to ${DateFormat('HH:mm').format(newStart)}");
                  }
                });
              }
            : null,

        // Change task duration
        onPanUpdate: task.isMovable
            ? (details) {
                setState(() {
                  Duration newDuration = task.endTime.difference(task.startTime) +
                      Duration(minutes: (details.primaryDelta! / hourHeight * 60).round());

                  if (newDuration.inMinutes > 10) {
                    // no 0-minute tasks
                    TaskModel updatedTask = task.copyWith(endTime: task.startTime.add(newDuration));
                    scheduleManager.editTask(updatedTask);
                    print(
                        "Resized Task: '${task.name}' - New Duration: ${newDuration.inMinutes} minutes");
                  }
                });
              }
            : null,

        child: Container(
          width: screenWidth * 0.75,
          height: hourHeight * task.endTime.difference(task.startTime).inHours,
          decoration: BoxDecoration(
            color: taskColor.withOpacity(0.3),
            border: Border.all(color: taskColor, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              Center(
                child: Text(task.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),

              // Toggle circle
              Positioned(
                left: 8,
                top: (hourHeight * task.endTime.difference(task.startTime).inHours) / 2 - 10,
                child: GestureDetector(
                  onTap: () {
                    scheduleManager.completeTask(task.id);
                    _fetchSchedule(); // refresh UI
                  },
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: taskColor, width: 2),
                      color: task.isComplete ? taskColor : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  final ScheduleManager scheduleManager;
  final Function refreshSchedule;
  final Difficulty difficulty;
  final TaskCategory topCategory;

  const BottomNavBar({
    super.key,
    required this.scheduleManager,
    required this.refreshSchedule,
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
                icon: const Icon(Icons.person, color: Colors.white, size: 25),
                onPressed: () async {
                  await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    isDismissible: true,
                    enableDrag: true,
                    backgroundColor: Colors.transparent,
                    //barrierColor: Colors.black.withOpacity(0.5),
                    shape: const ContinuousRectangleBorder(),
                    builder: (context) {
                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 50),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 1,
                            decoration: const BoxDecoration(
                              color: Color(0x00FFFFFF),
                              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                            ),
                            child: SingleChildScrollView(
                              child: ProfileScreen(difficulty: difficulty, topCategory: topCategory),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white, size: 25),
                onPressed: () async {
                  print("Before add: ${scheduleManager.schedule.toString()}");
                  final newTask = await showModalBottomSheet<TaskModel>(
                    context: context,
                    isScrollControlled: true,
                    isDismissible: true,
                    enableDrag: true,
                    backgroundColor: Colors.transparent,
                    barrierColor: Colors.black.withOpacity(0.5),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) {
                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 50),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.95,
                            decoration: const BoxDecoration(
                              color: Color(0x00FFFFFF),
                              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                            ),
                            child: SingleChildScrollView(
                              child: AddTaskScreen(scheduleManager: scheduleManager),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                  if (newTask != null) {
                    refreshSchedule();
                  }
                  print("After add: ${scheduleManager.schedule.toString()}");
                },
              ),
              const SizedBox(width: 40),
              IconButton(
                icon: const Icon(Icons.blur_on, color: Colors.white, size: 25),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white, size: 25),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsPage()),
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
              Icons.home,
              color: Color(0xFF00B3A1),
              size: 40,
            ),
          ),
        ),
      ],
    );
  }
}
//todo update icons to new flutter update

/* todo ADD NEW TASK popup to actually trial placement on homepage:
- Start Page with no */
//todo Implement and pass as userBinarySelect to ScheduleManager
// Display popup error message with the two provided choices
// Return bool: true if choice1 is selected, false if choice2 is selected

Future<bool> popupTwoChoices(String choice1, String choice2, String message) async {
  return true;
}

//todo implement and pass as displayErrorCallback to ScheduleManager
// Display a popup error message
void displayError(String message) {
  return;
}

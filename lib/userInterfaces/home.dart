//home page

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_75/models/task_model.dart'; // Correct TaskModel import
import 'package:student_75/Components/schedule_manager/schedule_manager.dart';
import 'package:student_75/Components/schedule_manager/schedule.dart'; // Correct Schedule import

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScheduleScreen(),
    );
  }
}

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final ScheduleManager scheduleManager = ScheduleManager(); // Backend instance
  Schedule currentSchedule = Schedule(tasks: []); // Stores tasks

  @override
  void initState() {
    super.initState();
    _addTestTasks();
    _fetchSchedule();
  }

  void _addTestTasks() {
    scheduleManager.addTask(TaskModel(
      id: 1,
      name: "Math Class",
      description: "Discrete",
      isMovable: true,
      category: TaskCategory.academic, // Example category
      priority: TaskPriority.high, // Example priority
      //location: location(name: "Room 101"), // Example location
      startTime: DateTime(2025, 3, 5, 9, 0),
      duration: Duration(hours: 1),
      notifyBefore: Duration(minutes: 15),
    ));

    scheduleManager.addTask(TaskModel(
      id: 2,
      name: "Comp Lab",
      description: "SETaP",
      isMovable: false, // Fixed schedule
      category: TaskCategory.social,
      priority: TaskPriority.medium,
      //location: Location(name: "Physics Building"),
      startTime: DateTime(2025, 3, 5, 11, 0),
      duration: Duration(hours: 1, minutes: 30),
      notifyBefore: Duration(minutes: 30),
    ));

    print("Test tasks added.");
  }

  Color _getTaskColor(TaskCategory category) {
    switch (category) {
      case TaskCategory.academic:
        return Colors.blue;
      case TaskCategory.social:
        return Colors.green;
      case TaskCategory.health:
        return Colors.red;
      case TaskCategory.employment:
        return Colors.orange;
      case TaskCategory.chore:
        return Colors.purple;
      case TaskCategory.hobby:
        return Colors.cyan;
    }
  }

  /// Tasks from backend
  void _fetchSchedule() {
    setState(() {
      currentSchedule = scheduleManager.getSchedule();
    });
    print("Fetched schedule from backend: ${currentSchedule.length} tasks loaded.");
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double topPadding = MediaQuery.of(context).padding.top;
    String currentDay = DateFormat('d').format(DateTime.now());
    String currentMonth = DateFormat('MMM').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavBar(),
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
    double topPadding = MediaQuery.of(context).padding.top; // Extra padding for iPhone 15 Pro

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
          SizedBox(height: 10), // Space for progress bar

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
          for (var task in currentSchedule.tasks) _buildDraggableTimeBlock(context, task),
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
              gradient: LinearGradient(
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
                child: Text(task.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),

              // Toggle circle
              Positioned(
                left: 8,
                top: (hourHeight * task.endTime.difference(task.startTime).inHours) / 2 - 10,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      TaskModel updatedTask = task.copyWith(isComplete: !task.isComplete);
                      scheduleManager.editTask(updatedTask);
                      print(
                          "Task '${task.name}' marked as ${updatedTask.isComplete ? "Completed" : "Incomplete"}");
                      _fetchSchedule(); // refresh UI
                    });
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
            icon: Icon(Icons.home, color: Colors.white),
            onPressed: () {},
          ),
          SizedBox(width: 40), // Space for FAB
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              print("Add Task button pressed."); // Debug
            },
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
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

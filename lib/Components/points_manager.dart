import 'package:student_75/Components/schedule_manager/schedule_manager.dart';
import 'package:student_75/models/task_model.dart';

class PointsManager {
  int maxPoints;
  int currentPoints;
  int pointsToPass;
  int completedTaskPoints;

  PointsManager(
      {required this.maxPoints,
      required this.currentPoints,
      required this.pointsToPass,
      required this.completedTaskPoints});

  // Method to calculate the total points
  int calculatePoints(List<TaskModel> calTasks) {
    int totalPoints = 0;
    for (var task in calTasks) {
      // int taskPoints = task.getPoint();
      // totalPoints += taskPoints;
    }
    return totalPoints;
  }

  void completedTasks() {
    // List<TaskModel> todaysTask = ScheduleManager.returnTodaySchedule();
    // List<TaskModel> completedTask =
    //     todaysTask.where((task) => task.isComplete).toList();
    // completedTaskPoints = calculatePoints(completedTask);
  }

  void calcPointsToPass() {
    pointsToPass = currentPoints - completedTaskPoints;
  }

  // Method to determine if the user has passed
  bool determinePass() {
    if (currentPoints == pointsToPass) {
      return true;
    }
    return false;
  }
}

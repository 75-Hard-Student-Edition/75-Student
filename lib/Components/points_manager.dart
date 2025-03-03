import 'package:student_75/models/task_model.dart';

class PointsManager {
  int maxPoints;
  int currentPoints;
  int pointsToPass;
  int completedTaskPoints;


  PointsManager({
    required this.maxPoints,
    required this.currentPoints,
    required this.pointsToPass,
    required this.completedTaskPoints
  });

  // Method to calculate the total points
  void calculatePoints(List<TaskModel> calTasks) {
    totalPoints = 0;
    for (var task in allTasks) {
      int taskPoint = task.getPoint();
      totalPoints += taskPoint;
    }
  }

  void completedTasks() {
    List<TaskModel> todaysTask = ScheduleManager.returnTodaySchedule();
    List<TaskModel> completedTask = todaysTask.where((task) => task.isComplete).toList();
    completedTaskPoints = calculatePoints(completedTask);
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

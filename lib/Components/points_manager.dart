import 'package:student_75/models/task_model.dart';

class PointsManager {
  int maxPoints;
  int currentPoints;
  int pointsToPass;


  PointsManager({
    required this.maxPoints,
    required this.currentPoints,
    required this.pointsToPass,
  });

  // Method to calculate the total points
  void calculateTotalPoints(List<TaskModel> allTasks) {
    currentPoints = 0;
    for (var task in allTasks) {
      int taskPoint = task.getPoint();
      currentPoints += taskPoint;
    }
  }

  // Method to mark a task as completed and add points
  void completeTask(TaskModel task) {
    // could this be in the task model class instead?
  }

  // Method to determine if the user has passed
  bool determinePass() {
    if (currentPoints == pointsToPass) {
      return true;
    }
    return false;
  }

  // Method to simulate a successful day
  void passDay() {
    // could we achieve the same with the determinepass method?
  }

  // Method to simulate a failed day
  void failDay() {
    // could we achieve the same with the determinepass method?
  }
}

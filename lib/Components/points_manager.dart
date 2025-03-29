import 'package:student_75/models/task_model.dart';
import "package:student_75/Components/schedule_manager/schedule.dart";
import 'package:student_75/Components/account_manager/account_manager.dart';

class PointsManager {
  int maxPoints;
  int currentPoints;
  int pointsToPass;
  int completedTaskPoints;
  late final AccountManager accountManager;
  late final List<TaskCategory> categoryOrder;

  PointsManager({
    required Schedule initialSchedule,
    required this.accountManager,
  }) {
    categoryOrder = accountManager.getCategoryOrder();
  }

  void addTask(TaskModel task) {
    int taskPoints = getTaskPoints(task);
    maxPoints += taskPoints;
  }

  int getTaskPoints(TaskModel task) {
    TaskCategory taskCategory = task.category;
    int taskPoints = categoryOrder.length - categoryOrder.indexOf(taskCategory);
    return taskPoints;
  }

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

import 'package:student_75/models/difficulty_enum.dart';
import 'package:student_75/models/task_model.dart';
import "package:student_75/Components/schedule_manager/schedule.dart";
import 'package:student_75/Components/account_manager/account_manager.dart';

class PointsManager {
  late int maxPoints;
  late int currentPoints;
  late int pointsToPass;
  late final AccountManager accountManager;
  late final List<TaskCategory> categoryOrder;
  Set<int> completedTasks = {};

  PointsManager({
    required Schedule initialSchedule,
    required this.accountManager,
  }) {
    categoryOrder = accountManager.getCategoryOrder();
    maxPoints = 0;
    currentPoints = 0;
  }

  void addTask(TaskModel task) {
    int taskPoints = getTaskPoints(task);
    maxPoints += taskPoints;
    calculatePointsToPass();
  }

  int getTaskPoints(TaskModel task) {
    TaskCategory taskCategory = task.category;
    int taskPoints = categoryOrder.length - categoryOrder.indexOf(taskCategory);
    return taskPoints;
  }

  void completeTask(TaskModel task) {
    int taskPoints = getTaskPoints(task);
    currentPoints += taskPoints;
    completedTasks.add(task.id);
  }

  void removeTask(TaskModel task) {
    int taskPoints = getTaskPoints(task);
    maxPoints -= taskPoints;

    if (maxPoints < 0) {
      maxPoints = 0;
    }
    calculatePointsToPass();

    if (completedTasks.contains(task.id)) {
      currentPoints -= taskPoints;
      completedTasks.remove(task.id);
    }
  }

  void calculatePointsToPass() =>
      pointsToPass = (maxPoints * accountManager.getDifficulty().value).round();

  bool determinePass() => currentPoints >= pointsToPass;
}

import 'package:student_75/models/difficulty_enum.dart';
import 'package:student_75/models/task_model.dart';
import "package:student_75/Components/schedule_manager/schedule.dart";
import 'package:student_75/Components/account_manager/account_manager.dart';

/// A class to manage the users points and use them to determine a pass/fail
class PointsManager {
  /// The maximum points possible for the current schedule
  late int maxPoints;

  /// The current points the user has
  late int currentPoints;

  /// The points needed to pass the day - a function of [maxPoints] and the difficulty level
  late int pointsToPass;

  /// The account manager to get the difficulty level and category order
  late final AccountManager accountManager;

  /// The order of categories to determine points for tasks
  late final List<TaskCategory> categoryOrder;

  /// A set of tasks that have been marked as completed - needed to maintain [currentPoints] integrity
  /// when a task is removed from the schedule
  Set<int> completedTasks = {};

  PointsManager({
    required Schedule initialSchedule,
    required this.accountManager,
  }) {
    categoryOrder = accountManager.getCategoryOrder();
    maxPoints = 0;
    currentPoints = 0;

    for (var task in initialSchedule.tasks) {
      addTask(task);
    }
  }

  /// Updates [maxPoints] and [pointsToPass] when a task is added to the schedule
  void addTask(TaskModel task) {
    int taskPoints = getTaskPoints(task);
    maxPoints += taskPoints;
    calculatePointsToPass();
  }

  /// Calculates the points for a task based on its category and the order of categories
  /// The higher the category is in the order, the more points it is worth
  int getTaskPoints(TaskModel task) {
    TaskCategory taskCategory = task.category;
    int taskPoints = categoryOrder.length - categoryOrder.indexOf(taskCategory);
    return taskPoints;
  }

  /// Updates [currentPoints] and [completedTasks] when a task is marked as completed
  void completeTask(TaskModel task) {
    int taskPoints = getTaskPoints(task);
    currentPoints += taskPoints;
    completedTasks.add(task.id);
  }

  /// Updates [currentPoints] and [completedTasks] when a task is removed from the schedule
  /// If the task is not in [completedTasks], it is not removed from [currentPoints]
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

  /// Calculates the points needed to pass based on the maximum points and the difficulty level
  /// The higher the difficulty level, the more points are needed to pass
  void calculatePointsToPass() =>
      pointsToPass = (maxPoints * accountManager.getDifficulty().value).round();

  /// Determines if [pointsToPass] has been reached
  /// Returns true if the user has passed, false otherwise
  bool determinePass() => currentPoints >= pointsToPass;
}

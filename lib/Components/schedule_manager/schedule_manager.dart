import 'package:student_75/models/task_model.dart';
import 'package:student_75/components/schedule.dart';
import 'package:student_75/components/points_manager.dart';
import 'package:student_75/components/notification_manager.dart';

// Interface for ScheduleManager to interact with the GUI
abstract class IScheduleManager {
  // ScheduleManager -> GUI methods
  Future<List<TaskModel>> getSchedule(DateTime date);
  Future<List<TaskModel>> getBacklogSuggestions();

  // GUI -> ScheduleManager methods
  void addTask(TaskModel task);
  Future<void> deleteTask(int taskId);
  Future<void> editTask(TaskModel task);
  Future<void> postPoneTask(int taskId);
  Future<void> completeTask(int taskId);
  Future<List<TaskModel>> scheduleBacklogSuggestion(int taskId);
}

class Backlog {/* Stub implementation of Backlog */}

class ScheduleManager implements IScheduleManager {
  late Schedule todaysSchedule;
  late Backlog backlog;
  late PointsManager pointsManager;
  late NotificationManager notificationManager;

  ScheduleManager() {
    //! All this data needs to be fetched by database service in constructor
    todaysSchedule = Schedule(tasks: []);
    backlog = Backlog();
    pointsManager = PointsManager(
      maxPoints: 100,
      currentPoints: 0,
      pointsToPass: 50,
    );
    notificationManager = NotificationManager(notifications: []);
  }

  // ScheduleManager -> GUI methods
  Future<List<TaskModel>> getSchedule(DateTime date) {}
  Future<List<TaskModel>> getBacklogSuggestions() {}

  // GUI -> ScheduleManager methods
  @override
  void addTask(TaskModel task) {
    // Add task to schedule
    todaysSchedule.add(task);
    // Add notification for task
    notificationManager.addNotification(task);
    //todo Update points
    // pointsManager.updatePoints(task);
  }

  Future<void> deleteTask(int taskId) {}
  Future<void> editTask(TaskModel task) {}
  Future<void> postPoneTask(int taskId) {}
  Future<void> completeTask(int taskId) {}
  Future<List<TaskModel>> scheduleBacklogSuggestion(int taskId) {}
}


  // void completeTask(int taskId) {
  //   int taskIndex = getTaskIndex(taskId);
  //   TaskModel task = tasks[taskIndex];
  //   tasks[taskIndex] = task.copyWith(isComplete: true);
  // }

  // void updateTask(TaskModel task) {
  //   int taskIndex = getTaskIndex(task.id);
  //   tasks[taskIndex] = task;
  // }
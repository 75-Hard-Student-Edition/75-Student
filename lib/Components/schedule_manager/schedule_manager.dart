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
  void deleteTask(int taskId);
  void editTask(TaskModel task);
  void postPoneTask(int taskId);
  void completeTask(int taskId);
  void scheduleBacklogSuggestion(int taskId);
}

class Backlog {
  /* Stub implementation of Backlog */
  void add(TaskModel task) {}
  TaskModel getTask(int taskId) {
    return TaskModel(
        id: taskId,
        name: 'Stub Task',
        isMovable: true,
        category: TaskCategory.academic,
        priority: TaskPriority.low,
        startTime: DateTime.now(),
        duration: const Duration(hours: 1),
        period: const Duration(days: 1));
  }

  void remove(int taskId) {}
}

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

  @override
  void deleteTask(int taskId) {
    // Remove task from schedule
    todaysSchedule.remove(taskId);
    // Remove notification for task
    notificationManager.removeNotification(taskId);
    //todo Update points
    // pointsManager.updatePoints(task);
  }

  @override
  void editTask(TaskModel task) {
    // Works by deleting and re-adding the task, assuming that the task ID is not changed
    deleteTask(task.id);
    addTask(task);
  }

  @override
  void postPoneTask(int taskId) {
    // Add task to backlog
    final TaskModel task = todaysSchedule.getTaskModel(taskId);
    backlog.add(task);
    // Remove task from schedule
    deleteTask(taskId);
  }

  @override
  void completeTask(int taskId) {
    final int taskIndex = todaysSchedule.getTaskIndex(taskId);
    final TaskModel task = todaysSchedule.tasks[taskIndex];
    todaysSchedule.tasks[taskIndex] = task.copyWith(isComplete: true);
  }

  @override
  void scheduleBacklogSuggestion(int taskId) {
    // Fetch task from backlog
    final TaskModel task = backlog.getTask(taskId);
    // Add task to schedule
    addTask(task);
    // Remove task from backlog
    backlog.remove(taskId);
  }
}

import 'package:student_75/Components/account_manager/account_manager.dart';
import 'package:student_75/Components/schedule_manager/schedule_manager_interface.dart';
import 'package:student_75/Components/points_manager.dart';
import 'package:student_75/app_settings.dart';
import 'package:student_75/database/database_service.dart';
import 'package:student_75/models/task_model.dart';
import 'package:student_75/Components/schedule_manager/schedule.dart';
import 'package:student_75/Components/schedule_manager/schedule_generator.dart';
import 'package:student_75/Components/notification_manager.dart';
import 'package:student_75/Components/schedule_manager/backlog.dart';

// Interface for ScheduleManager to interact with the GUI

class TaskOverlapException implements Exception {
  final String message;
  TaskOverlapException(this.message);

  @override
  String toString() => 'TaskOverlapException: $message';
}

class TaskNotFoundException implements Exception {
  final String message;
  TaskNotFoundException(this.message);

  @override
  String toString() => 'TaskNotFoundException: $message';
}

class ScheduleManager implements IScheduleManager {
  late Schedule todaysSchedule;
  late Backlog backlog;
  late PointsManager pointsManager;
  late AccountManager accountManager;
  late NotificationManager notificationManager;
  late Future<TaskModel?> Function(TaskModel, TaskModel, String) userBinarySelectCallback;
  late void Function(String) displayErrorCallback;

  // Private constructor
  ScheduleManager._();

  // Async factory method
  static Future<ScheduleManager> create({
    required void Function(String) displayErrorCallback,
    required AccountManager accountManager,
    required Future<TaskModel?> Function(TaskModel, TaskModel, String) userBinarySelectCallback,
  }) async {
    final instance = ScheduleManager._();
    instance.displayErrorCallback = displayErrorCallback;
    instance.accountManager = accountManager;
    instance.userBinarySelectCallback = userBinarySelectCallback;

    await instance._initialize();
    return instance;
  }

  Future<void> _initialize() async {
    todaysSchedule = Schedule(
        tasks: await DatabaseService().fetchTodaysScheduledTasks(accountManager.userAccount!.id));
    backlog = Backlog(initialTasks: []);
    pointsManager = PointsManager(initialSchedule: todaysSchedule, accountManager: accountManager);
    notificationManager = NotificationManager(notifications: []);

    print("ScheduleManager initialised with the following account data:");
    print(accountManager.userAccount.toString());
  }

  //* == ScheduleManager -> GUI methods ==
  @override
  Schedule get schedule => todaysSchedule;

  @override
  List<TaskModel> getBacklogSuggestions() => backlog.peak(AppSettings.backlogPeakDepth);

  @override
  Future<TaskModel?> userBinarySelect(TaskModel task1, TaskModel task2, String message) async =>
      await userBinarySelectCallback(task1, task2, message);
  @override
  void displayError(String message) {
    displayErrorCallback(message);
  }

  @override
  AccountManager get accManager => accountManager;

  //* == GUI -> ScheduleManager methods ==
  @override
  void addTask(TaskModel task) {
    print("Adding task: ${task.toString()}");
    // Add task to schedule
    try {
      todaysSchedule.add(task);
    } on TaskOverlapException catch (e) {
      throw TaskOverlapException("Tasks overlapping");
    } catch (e) {
      // Handle other exceptions
      displayError("Uncaught Exception on addTask: ${e.toString()}");
    }
    // Add notification for task
    notificationManager.addNotification(task);
    // Update points
    pointsManager.addTask(task);
    // Update database
    DatabaseService().addTaskRecord(task, accountManager.userAccount!.id);
  }

  @override
  void deleteTask(int taskId) async {
    print("Deleting task with id: $taskId");
    // Remove task from schedule
    try {
      pointsManager.removeTask(todaysSchedule.getTaskModelFromId(taskId)!);
      todaysSchedule.remove(taskId);
    } on TaskNotFoundException catch (e) {
      displayError(e.toString());
    } catch (e) {
      // Handle other exceptions
      displayError("Uncaught Exception on deleteTask: ${e.toString()}");
    }
    // Remove notification for task
    notificationManager.removeNotification(taskId);
    // Update database
    await DatabaseService().removeTaskRecord(taskId);
  }

  @override
  void editTask(TaskModel updatedTask) {
    print("Editing task: ${updatedTask.toString()}");
    try {
      // Check for overlap *excluding* itself
      for (var otherTask in todaysSchedule.tasks) {
        if (otherTask.id != updatedTask.id &&
            otherTask.startTime.isBefore(updatedTask.endTime) &&
            otherTask.endTime.isAfter(updatedTask.startTime)) {
          throw TaskOverlapException('Tasks overlapping');
        }
      }
      deleteTask(updatedTask.id);
      addTask(updatedTask);
    } on TaskOverlapException {
      rethrow;
    } catch (e) {
      displayError("Uncaught Exception on editTask: ${e.toString()}");
    }
    // Update Database
    DatabaseService().updateTaskRecord(updatedTask, accountManager.userAccount!.id);
  }

  @override
  void postPoneTask(int taskId) {
    // Add task to backlog
    try {
      final TaskModel? task = todaysSchedule.getTaskModelFromId(taskId);
      backlog.enqueue(task!);
    } on TaskNotFoundException catch (e) {
      throw TaskNotFoundException(
          "Task with id '$taskId' not found in schedule when trying to postpone: ${e.message}");
    }
    // Remove task from schedule
    deleteTask(taskId);
  }

  @override
  void completeTask(int taskId) {
    final int taskIndex = todaysSchedule.getTaskIndexFromId(taskId);
    final TaskModel task = todaysSchedule.tasks[taskIndex];
    editTask(task.copyWith(isComplete: true));
    pointsManager.completeTask(task);
    DatabaseService()
        .updateTaskRecord(task.copyWith(isComplete: true), accountManager.userAccount!.id);
  }

  @override
  void uncompleteTask(int taskId) {
    final int taskIndex = todaysSchedule.getTaskIndexFromId(taskId);
    final TaskModel task = todaysSchedule.tasks[taskIndex];
    editTask(task.copyWith(isComplete: false));
    pointsManager.uncompleteTask(task);
    DatabaseService()
        .updateTaskRecord(task.copyWith(isComplete: false), accountManager.userAccount!.id);
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

  @override
  DateTime? findAvailableTimeSlot(TaskModel task) =>
      ScheduleGenerator.checkMovePossible(todaysSchedule, task, accountManager);

  //* == Internal methods ==
  Future<void> endOfDayProcess() async {
    backlog.age();
    //* 1. Process old schedule
    for (final task in todaysSchedule.tasks) {
      if (task.isComplete) {
        if (task.period != null) {
          // DatabaseServeice.updateTaskRecord(task.copyWith(nextScheduled: task.nextScheduled.add(task.period!)));
        } else {
          // DatabaseServeice.deleteTaskRecord(task.id);
        }
      } else if (task.isMovable) {
        // Add task to backlog - have to figure this out in the database
        backlog.enqueue(task);
      } else {
        deleteTask(task.id);
      }
    }
    //if (pointsManager.determinePass()) {
    // DatabaseService.updateUserRecord(); // Increment streak somehow
    //} else {
    // DatabaseService.updateUserRecord(); // Reset streak somehow
    //}

    //* 2. Generate new schedule
    ScheduleGenerator scheduleGenerator = ScheduleGenerator(this);
    final Schedule sanitisedSchedule = await scheduleGenerator.generateSanitisedSchedule();

    //* 4. Add new schedule to todays schedule
    todaysSchedule = sanitisedSchedule;
  }

  Future<void> generateSanitisedSchedule() async {
    ScheduleGenerator scheduleGenerator = ScheduleGenerator(this);
    final Schedule sanitisedSchedule = await scheduleGenerator.generateSanitisedSchedule();
    todaysSchedule = sanitisedSchedule;
  }
}

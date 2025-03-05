import 'package:student_75/Components/schedule_manager/schedule_manager_interface.dart';
import 'package:student_75/models/task_model.dart';
import 'package:student_75/Components/schedule_manager/schedule.dart';
import 'package:student_75/Components/schedule_manager/schedule_generator.dart';
import 'package:student_75/Components/points_manager.dart';
import 'package:student_75/Components/notification_manager.dart';

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

class Backlog {
  /* Stub implementation of Backlog */
  void add(TaskModel task) {}
  TaskModel getTask(int taskId) => TaskModel(
      id: taskId,
      name: 'Stub Task',
      isMovable: true,
      category: TaskCategory.academic,
      priority: TaskPriority.low,
      startTime: DateTime.now(),
      duration: const Duration(hours: 1),
      period: const Duration(days: 1));
  void remove(int taskId) {}
  List<TaskModel> peak(int depth) => [
        TaskModel(
            id: 0,
            name: 'Stub Task',
            isMovable: true,
            category: TaskCategory.academic,
            priority: TaskPriority.low,
            startTime: DateTime.now(),
            duration: const Duration(hours: 1),
            period: const Duration(days: 1))
      ];
}

class ScheduleManager implements IScheduleManager {
  late Schedule todaysSchedule;
  late Backlog backlog;
  //late PointsManager pointsManager;
  late NotificationManager notificationManager;
  late Future<bool> Function(String, String, String) userBinarySelectCallback;
  late void Function(String) displayErrorCallback;

  ScheduleManager(){//this.userBinarySelectCallback, this.displayErrorCallback) {
    //todo All this data needs to be fetched by database service in constructor
    todaysSchedule = Schedule(tasks: []);
    backlog = Backlog();
    /* pointsManager = PointsManager(
        maxPoints: 100,
        currentPoints: 0,
        pointsToPass: 50,
        completedTaskPoints: 0); */
    notificationManager = NotificationManager(notifications: []);
  }

  //* == ScheduleManager -> GUI methods ==
  @override
  List<TaskModel> getSchedule() => todaysSchedule.tasks;
  @override
  //todo Decide on some way of deciding peak depth
  List<TaskModel> getBacklogSuggestions() => backlog.peak(5);
  @override
  Future<bool> userBinarySelect(
          String choice1, String choice2, String message) =>
      userBinarySelectCallback(choice1, choice2, message);
  @override
  void displayError(String message) {
    displayErrorCallback(message);
  }

  //* == GUI -> ScheduleManager methods ==
  @override
  void addTask(TaskModel task) {
    // Add task to schedule
    try {
      todaysSchedule.add(task);
    } on TaskOverlapException catch (e) {
      displayError(e.toString());
    } catch (e) {
      // Handle other exceptions
      displayError("Uncaught Exception on addTask: ${e.toString()}");
    }
    // Add notification for task
    notificationManager.addNotification(task);
    //todo Update points
    // pointsManager.updatePoints(task);
    //todo Update database
    // databaseService.addTaskRecord(task);
  }

  @override
  void deleteTask(int taskId) {
    // Remove task from schedule
    try {
      todaysSchedule.remove(taskId);
    } on TaskNotFoundException catch (e) {
      displayError(e.toString());
    } catch (e) {
      // Handle other exceptions
      displayError("Uncaught Exception on deleteTask: ${e.toString()}");
    }
    // Remove notification for task
    notificationManager.removeNotification(taskId);
    //todo Update points
    // pointsManager.updatePoints(task);
    //todo Update database
    // databaseService.deleteTaskRecord(taskId);
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
    final TaskModel? task = todaysSchedule.getTaskModelFromId(taskId);
    if (task == null) {
      throw TaskNotFoundException(
          "Task with id '$taskId' not found in schedule when trying to postpone");
    }
    backlog.add(task);
    // Remove task from schedule
    deleteTask(taskId);
  }

  @override
  void completeTask(int taskId) {
    final int taskIndex = todaysSchedule.getTaskIndexFromId(taskId);
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

  //* == Internal methods ==
  Future<void> endOfDayProcess() async {
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
        backlog.add(task);
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
    final Schedule sanitisedSchedule =
        await scheduleGenerator.generateSanitisedSchedule();

    //* 4. Add new schedule to todays schedule
    todaysSchedule = sanitisedSchedule;
  }

  Schedule returnTodaySchedule() {
    return todaysSchedule;
  }
}

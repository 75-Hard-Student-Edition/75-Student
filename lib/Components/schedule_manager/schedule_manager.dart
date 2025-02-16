import 'package:student_75/models/task_model.dart';
import 'package:student_75/components/schedule.dart';
import 'package:student_75/components/points_manager.dart';
import 'package:student_75/components/notification_manager.dart';

// Interface for ScheduleManager to interact with the GUI
abstract class IScheduleManager {
  // ScheduleManager -> GUI methods
  List<TaskModel> getSchedule();
  List<TaskModel> getBacklogSuggestions();

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

  //* == ScheduleManager -> GUI methods ==
  @override
  List<TaskModel> getSchedule() => todaysSchedule.tasks;
  @override
  //todo Decide on some way of deciding peak depth
  List<TaskModel> getBacklogSuggestions() => backlog.peak(5);

  //* == GUI -> ScheduleManager methods ==
  @override
  void addTask(TaskModel task) {
    // Add task to schedule
    todaysSchedule.add(task);
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
    todaysSchedule.remove(taskId);
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

  //* == Internal methods ==
  void endOfDayProcess() {
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
        //! Have to decide what to do if the task is not complete or movable
      }
    }
    if (pointsManager.determinePass()) {
      // DatabaseService.updateUserRecord(); // Increment streak somehow
    } else {
      // DatabaseService.updateUserRecord(); // Reset streak somehow
    }

    //* 2. Fetch new automatic schedule
    List<TaskModel> newScheduleTasks =
        []; //todo Fetch new schedule from database

    //* 3. Order new schedule
    List<TaskModel> sanitisedSchedule = santitiseSchedule(newScheduleTasks);

    //* 4. Add new schedule to todays schedule
    todaysSchedule = Schedule(tasks: sanitisedSchedule);
  }

  List<TaskModel> santitiseSchedule(List<TaskModel> schedule) {
    // Empty or singleton schedules are automatically valid
    if (schedule.isEmpty || schedule.length == 1) return schedule;

    // Sort Schedule by start time
    schedule.sort((a, b) => a.startTime.compareTo(b.startTime));

    bool passIsClean = false;
    while (!passIsClean) {
      passIsClean = true;
      int nextTaskIndex = 1;

      // Need to break any time the pass is not clean to ensure we are not mutating the list while iterating
      while (nextTaskIndex < schedule.length && passIsClean) {
        TaskModel currentTask = schedule[nextTaskIndex - 1];
        TaskModel nextTask = schedule[nextTaskIndex];

        // Check for overlap
        if (!currentTask.endTime.isAfter(nextTask.startTime)) {
          // If there is no overlap, move to the next task
          nextTaskIndex++;
          continue;
        }

        passIsClean = false;

        // Handle overlap

        if (!currentTask.isMovable && !currentTask.isMovable) {
          // If neither task is movable, and overlapping, we have a problem
          //? Currently I've implemented this as an exception but we could also remove the task with the lower priority
          throw Exception(
              'Tasks ${currentTask.id} and ${nextTask.id} overlap and are not movable');
        }

        if (nextTask.isMovable) {
          // If the next task is movable, attempt to move it
          List<TaskModel> movedSchedule = attemptMove(schedule, nextTaskIndex);
          if (movedSchedule != schedule) {
            schedule = movedSchedule;
            //? Maybe continue instead im not sure
            break;
          }
        } else {
          // If the current task is movable, attempt to move it
          List<TaskModel> movedSchedule =
              attemptMove(schedule, nextTaskIndex - 1);
          if (movedSchedule != schedule) {
            schedule = movedSchedule;
            //? Maybe continue instead im not sure
            break;
          }
        }

        // If we reach this point, we have failed to move the tasks
        // Therefore, we must postPone the task that can be moved, or the lower priority if they both can
        if (currentTask.isMovable && nextTask.isMovable) {
          // If both tasks are movable, postpone the lower priority task
          if (currentTask.priority.index < nextTask.priority.index) {
            postPoneTask(nextTask.id);
          } else {
            postPoneTask(currentTask.id);
          }
        } else if (currentTask.isMovable) {
          postPoneTask(currentTask.id);
        } else {
          postPoneTask(nextTask.id);
        }
      }
    }
    return schedule;
  }

  List<TaskModel> attemptMove(List<TaskModel> schedule, int taskIndex) {
    //todo Implement this - make no change if not possible
    return schedule;
  }
}

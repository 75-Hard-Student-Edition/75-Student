import 'package:student_75/Components/account_manager/account_manager.dart';
import 'package:student_75/models/task_model.dart';
import 'package:student_75/Components/schedule_manager/schedule.dart';
import 'package:student_75/Components/schedule_manager/schedule_manager_interface.dart';

class ScheduleGenerator {
  final IScheduleManager _scheduleManager;

  ScheduleGenerator(this._scheduleManager);

  Future<Schedule> generateSanitisedSchedule() async {
    Schedule schedule = Schedule(tasks: []); // databaseService.getSchedule(); or smtn
    if (schedule.isEmpty || schedule.length == 1) return schedule;

    schedule.sort();

    bool passIsClean = false;
    while (!passIsClean) {
      passIsClean = true;

      for (int i = 0; i < schedule.length - 1; i++) {
        TaskModel currentTask = schedule.tasks[i];
        TaskModel nextTask = schedule.tasks[i + 1];

        if (!currentTask.endTime.isAfter(nextTask.startTime)) {
          continue;
        }

        // Overlap detected
        passIsClean = false;
        schedule = await handleOverlap(schedule, currentTask, nextTask);
        break;
      }
    }
    return schedule;
  }

  /// Method to handle cases where two tasks overlap
  /// Returns a schedule with the overlapping tasks resolved
  ///
  /// Overlap cases:
  ///   2. Neither tasks movable
  ///     a. Different priority - delete lower priority
  ///     b. Same priority - USER selects which task to delete
  ///   3. One task movable
  ///     a. Move is possible - USER selects to move or postpone task
  ///     b. Move is impossible - postpone task
  ///   4. Both tasks movable
  ///     a. Same priority - USER selects which task to edit
  ///       i. Move is possible - USER selects to move or postpone task
  ///       ii. Move is impossible - postpone task
  ///     b. Different priority - edit lower priority task
  ///       i. Move is possible - USER selects to move or postpone task
  ///       ii. Move is impossible - postpone task
  Future<Schedule> handleOverlap(
      Schedule schedule, TaskModel currentTask, TaskModel nextTask) async {
    Schedule sanitisedSchedule = schedule;
    List<TaskModel> movableTasks = [currentTask, nextTask].where((task) => task.isMovable).toList();
    TaskModel? lowerPriority = currentTask.priority.index > nextTask.priority.index
        ? nextTask
        : currentTask.priority.index < nextTask.priority.index
            ? currentTask
            : null; // Null if equal priority

    if (movableTasks.isEmpty) {
      if (lowerPriority == null) {
        // Same priority
        // USER selects which task to delete
        TaskModel? userChoice = await _scheduleManager.userBinarySelect(
            currentTask, nextTask, "Which task would you like to delete?");
        _scheduleManager.deleteTask(userChoice!.id);
        sanitisedSchedule.remove(userChoice.id);
      } else {
        // Different priority
        // Delete lower priority task
        _scheduleManager.deleteTask(lowerPriority.id);
        sanitisedSchedule.remove(lowerPriority.id);
      }
      return sanitisedSchedule;
    }

    if (movableTasks.length == 1) {
      TaskModel movableTask = movableTasks.first;
      moveOrPostponeTask(schedule, movableTask);
      return sanitisedSchedule;
    }

    // Both tasks movable
    if (lowerPriority == null) {
      // Same priority
      // USER selects which task to edit
      TaskModel? userChoice = await _scheduleManager.userBinarySelect(
          currentTask, nextTask, "Which task would you like to edit?");
      moveOrPostponeTask(schedule, userChoice!);
    } else {
      // Different priority
      // Edit lower priority task
      moveOrPostponeTask(schedule, lowerPriority);
    }

    return sanitisedSchedule;
  }

  /// Method to check if a task can be moved to a different time
  /// Returns a datetime if possible, or null if not possible
  static DateTime? checkMovePossible(
      Schedule schedule, TaskModel task, AccountManager accountManager) {
    Duration taskDuration = task.endTime.difference(task.startTime);

    for (int i = 0; i < schedule.length - 1; i++) {
      TaskModel currentTask = schedule.tasks[i];
      TaskModel nextTask = schedule.tasks[i + 1];

      if (currentTask.id == task.id || nextTask.id == task.id) continue;

      Duration gap = nextTask.startTime.difference(currentTask.endTime) - const Duration(hours: 1);
      if (gap >= taskDuration) return currentTask.endTime.add(const Duration(minutes: 30));
    }

    // Handle edge cases of moving task to start or end of day
    DateTime wakeupTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      accountManager.userAccount!.bedtime!.hour,
      accountManager.userAccount!.bedtime!.minute,
    ).add(accountManager.userAccount!.sleepDuration!);

    Duration timeFromWakeup = task.startTime.difference(wakeupTime);
    if (timeFromWakeup >= taskDuration) return wakeupTime;

    DateTime bedtime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      accountManager.userAccount!.bedtime!.hour,
      accountManager.userAccount!.bedtime!.minute,
    );
    Duration timeToBedtime = schedule.last.endTime.difference(bedtime);
    if (timeToBedtime >= taskDuration) return bedtime.subtract(taskDuration);

    return null; // No available time slot found
  }

  Future<void> moveOrPostponeTask(Schedule schedule, TaskModel task) async {
    // USER selects to move or postpone task
    if (checkMovePossible(schedule, task, _scheduleManager.accManager) != null) {
      // Move is possible
      //sorry
      TaskModel? userChoice = await _scheduleManager.userBinarySelect(
          TaskModel(
              id: -1,
              name: "Move",
              isMovable: false,
              category: TaskCategory.health,
              priority: TaskPriority.medium,
              startTime: DateTime.now(),
              duration: Duration.zero),
          TaskModel(
              id: -1,
              name: "Postpone",
              isMovable: false,
              category: TaskCategory.health,
              priority: TaskPriority.medium,
              startTime: DateTime.now(),
              duration: Duration.zero),
          "Would you like to move or postpone the task?");
      if (userChoice!.name == "Move") {
        // Move task
        // _scheduleManager.moveTask(task); // todo implement this
      } else {
        // Postpone task
        _scheduleManager.postPoneTask(task.id);
      }
    } else {
      // Move is impossible
      _scheduleManager.postPoneTask(task.id);
    }
  }
}

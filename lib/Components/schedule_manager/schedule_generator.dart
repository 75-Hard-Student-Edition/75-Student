import 'package:student_75/models/task_model.dart';
import 'package:student_75/Components/schedule_manager/schedule.dart';
import 'package:student_75/Components/schedule_manager/schedule_manager.dart';

class ScheduleGenerator {
  ScheduleManager _scheduleManager;

  ScheduleGenerator(this._scheduleManager);

  Schedule generateSanitisedSchedule() {
    Schedule schedule = Schedule(tasks: []); // databaseService.getSchedule(); or smtn
    if (schedule.isEmpty || schedule.length == 1) return schedule;

    schedule.sort();

    bool passIsClean = false;
    while (!passIsClean) {
      passIsClean = true;

      for (int i = 0; i < schedule.length - 1; i++) {
        TaskModel currentTask = schedule.getTaskModel(i);
        TaskModel nextTask = schedule.getTaskModel(i + 1);

        if (!currentTask.endTime.isAfter(nextTask.startTime)) {
          continue;
        }

        // Overlap detected
        passIsClean = false;
        schedule = handleOverlap(schedule, currentTask, nextTask);
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
  Schedule handleOverlap(Schedule schedule, TaskModel currentTask, TaskModel nextTask) {
    Schedule sanitisedSchedule = schedule;
    List<TaskModel> movableTasks = [currentTask, nextTask].where((task) => task.isMovable).toList();
    TaskModel? lowerPriority = currentTask.priority.index > nextTask.priority.index
        ? nextTask
        : currentTask.priority.index < nextTask.priority.index
            ? currentTask
            : null; // Null if equal priority

    if (movableTasks.isEmpty) {
      //todo Implement this case
      if (lowerPriority == null) {
        // Same priority
        // USER selects which task to delete
        // taskToDelete = await someComponent.userSelectTaskToDelete(currentTask, nextTask);
        TaskModel taskToDelete = currentTask; // todo implement this
        _scheduleManager.deleteTask(taskToDelete.id);
        sanitisedSchedule.remove(taskToDelete.id);
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
    //todo Implement this case
    if (lowerPriority == null) {
      // Same priority
      // USER selects which task to edit
      // TaskModel taskToEdit = await someComponent.userSelectTaskToEdit(currentTask, nextTask);
      TaskModel taskToEdit = currentTask; // todo implement this
      moveOrPostponeTask(schedule, taskToEdit);
    } else {
      // Different priority
      // Edit lower priority task
      moveOrPostponeTask(schedule, lowerPriority);
    }

    return sanitisedSchedule;
  }

  static bool checkMovePossible(Schedule schedule, TaskModel task) {
    // Check if task can be moved to a different time
    // return true if possible, false otherwise
    Duration taskDuration = task.endTime.difference(task.startTime);

    for (int i = 0; i < schedule.length - 1; i++) {
      TaskModel currentTask = schedule.getTaskModel(i);
      TaskModel nextTask = schedule.getTaskModel(i + 1);

      if (currentTask.id == task.id || nextTask.id == task.id) continue;

      Duration gap = nextTask.startTime.difference(currentTask.endTime);
      if (gap >= taskDuration) return true;
    }

    // Handle edge cases of moving task to start or end of day
    Duration timeFromWakeup =
        task.startTime.difference(/* some way to fetch wakeup time */ DateTime.now());
    if (timeFromWakeup >= taskDuration) return true;

    Duration timeToBedtime =
        schedule.last.endTime.difference(/* some way to fetch bedtime */ DateTime.now());
    return timeToBedtime >= taskDuration;
  }

  Future<void> moveOrPostponeTask(Schedule schedule, TaskModel task) async {
    //todo Implement this method
    // USER selects to move or postpone task
    if (checkMovePossible(schedule, task)) {
      // Move is possible
      // if (await someComponent.userSelectMoveOrPostpone(task)) {
      // _scheduleManager.moveTask(task); todo implement this
      // } else {
      _scheduleManager.postPoneTask(task.id);
      // }
    } else {
      // Move is impossible
      _scheduleManager.postPoneTask(task.id);
    }
  }
}

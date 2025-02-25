import 'package:student_75/models/task_model.dart';
import 'package:student_75/components/schedule_manager/schedule_manager.dart';

class ScheduleGenerator {
  IScheduleManager _scheduleManager;

  ScheduleGenerator(this._scheduleManager);

  List<TaskModel> generateSanitisedSchedule() {
    List<TaskModel> schedule = []; // databaseService.getSchedule(); or smtn
    if (schedule.isEmpty || schedule.length == 1) return schedule;

    schedule.sort((a, b) => a.startTime.compareTo(b.startTime));

    bool passIsClean = false;
    while (!passIsClean) {
      passIsClean = true;

      for (int i = 0; i < schedule.length - 1; i++) {
        TaskModel currentTask = schedule[i];
        TaskModel nextTask = schedule[i + 1];

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
  List<TaskModel> handleOverlap(
      List<TaskModel> schedule, TaskModel currentTask, TaskModel nextTask) {
    List<TaskModel> sanitisedSchedule = schedule;
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
        // sanitisedSchedule.remove(taskToDelete);
      } else {
        // Different priority
        // Delete lower priority task
        // scheduleManager.deleteTask(lowerPriority.id);
        // sanitisedSchedule.remove(lowerPriority);
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
      // moveOrPostponeTask(schedule, taskToEdit);
    } else {
      // Different priority
      // Edit lower priority task
      // moveOrPostponeTask(schedule, lowerPriority);
    }

    return sanitisedSchedule;
  }

  static bool checkMovePossible(List<TaskModel> schedule, TaskModel task) {
    //todo Implement this method
    // Check if task can be moved to a different time
    // return true if possible, false otherwise
    return true;
  }

  Future<void> moveOrPostponeTask(List<TaskModel> schedule, TaskModel task) async {
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

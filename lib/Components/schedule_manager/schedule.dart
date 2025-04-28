import 'package:student_75/models/task_model.dart';
import 'package:student_75/Components/schedule_manager/schedule_manager.dart';

/// Represents a schedule object; a container for tasks
class Schedule {
  /// The list of tasks in the schedule
  List<TaskModel> tasks;

  /// Returns true if the schedule is empty
  bool get isEmpty => tasks.isEmpty;

  /// Returns the number of tasks in the schedule
  int get length => tasks.length;

  /// Returns the last task in the schedule
  TaskModel get last => tasks.last;

  /// Creates a [Schedule] object with the given list of tasks
  Schedule({required this.tasks});

  /// Sorts the [tasks] in the schedule by start time
  void sort() => tasks.sort((a, b) => a.startTime.compareTo(b.startTime));

  /// Adds a task to the schedule
  ///
  /// Throws a [TaskOverlapException] if the task overlaps with another task
  void add(TaskModel task) {
    tasks.add(task);
    sort();
    int i = getTaskIndexFromId(task.id);
    // if (i == 0 || i == tasks.length - 1) return;
    if (tasks.length == 1) return;

    if (i != 0) {
      TaskModel prevTask = tasks[i - 1];
      if (prevTask.endTime.isAfter(task.startTime)) {
        remove(task.id);
        throw TaskOverlapException("Task overlaps with previous task");
      }
    }
    if (i == tasks.length - 1) return;
    TaskModel nextTask = tasks[i + 1];
    if (task.endTime.isAfter(nextTask.startTime)) {
      remove(task.id);
      throw TaskOverlapException("Task overlaps with next task");
    }
  }

  /// Removes a task from the schedule
  ///
  /// Throws a [TaskNotFoundException] if the task is not found in the schedule
  void remove(int taskId) {
    TaskModel? task = getTaskModelFromId(taskId);
    if (task == null) {
      throw TaskNotFoundException(
          "Task with id '$taskId' not found in schedule when trying to remove");
    }
    tasks.remove(task);
  }

  /// Replaces a task in the schedule with a new task
  ///
  /// The new task must have the same id as the task to be replaced
  /// Throws a [TaskNotFoundException] if the task is not found in the schedule
  void editTask(TaskModel newTask) {
    int i = getTaskIndexFromId(newTask.id);
    if (i == -1) {
      throw TaskNotFoundException(
          "Task with id '${newTask.id}' not found in schedule when trying to edit");
    }
    tasks[i] = newTask;
    sort();
  }

  /// Returns the index of a task in the schedule with the given id
  ///
  /// Returns -1 if the task is not found
  int getTaskIndexFromId(int taskId) {
    for (int i = 0; i < tasks.length; i++) {
      TaskModel task = tasks[i];
      if (task.id == taskId) return i;
    }
    return -1;
  }

  /// Returns the [TaskModel] in the schedule with the given id
  ///
  /// Returns null if the task is not found
  TaskModel? getTaskModelFromId(int taskId) {
    int index = getTaskIndexFromId(taskId);
    if (index == -1) return null;
    return tasks[index];
  }

  @override
  toString() {
    String out = "Schedule: [\n";
    for (TaskModel task in tasks) {
      out += "  $task\n";
    }
    return "$out]";
  }
}

import 'package:student_75/models/task_model.dart';
import 'package:student_75/Components/schedule_manager/schedule_manager.dart';

class Schedule {
  List<TaskModel> tasks;
  bool get isEmpty => tasks.isEmpty;
  int get length => tasks.length;
  TaskModel get last => tasks.last;

  Schedule({required this.tasks});

  void sort() => tasks.sort((a, b) => a.startTime.compareTo(b.startTime));

  // Method to add a task to the schedule
  void add(TaskModel task) {
    tasks.add(task);
    sort();
    int i = getTaskIndexFromId(task.id);
    if (i == 0 || i == tasks.length - 1) return;

    TaskModel prevTask = tasks[i - 1];
    if (prevTask.endTime.isAfter(task.startTime)) {
      remove(task.id);
      throw TaskOverlapException("Task overlaps with previous task");
    }
    TaskModel nextTask = tasks[i + 1];
    if (task.endTime.isAfter(nextTask.startTime)) {
      remove(task.id);
      throw TaskOverlapException("Task overlaps with next task");
    }
  }

  // Method to remove a task from the schedule by task ID
  void remove(int taskId) {
    TaskModel? task = getTaskModelFromId(taskId);
    if (task == null) {
      throw TaskNotFoundException(
          "Task with id '$taskId' not found in schedule when trying to remove");
    }
    tasks.remove(task);
  }

  void editTask(TaskModel newTask) {
    int i = getTaskIndexFromId(newTask.id);
    if (i == -1) {
      throw TaskNotFoundException(
          "Task with id '${newTask.id}' not found in schedule when trying to edit");
    }
    tasks[i] = newTask;
    sort();
  }

  int getTaskIndexFromId(int taskId) {
    for (int i = 0; i < tasks.length; i++) {
      TaskModel task = tasks[i];
      if (task.id == taskId) return i;
    }
    return -1;
  }

  TaskModel? getTaskModelFromId(int taskId) {
    int index = getTaskIndexFromId(taskId);
    if (index == -1) return null;
    return tasks[index];
  }
}

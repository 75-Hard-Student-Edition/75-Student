import 'package:student_75/models/task_model.dart';

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
    int i = getTaskIndex(task.id);
    if (i == 0 || i == tasks.length - 1) return;

    TaskModel prevTask = tasks[i - 1];
    if (prevTask.endTime.isAfter(task.startTime)) {
      //todo handle overlap
    }
    TaskModel nextTask = tasks[i + 1];
    if (task.endTime.isAfter(nextTask.startTime)) {
      //todo handle overlap
    }
  }

  // Method to remove a task from the schedule by task ID
  void remove(int taskId) {
    //! Use the getTaskIndex method to get the index of the task
    tasks.remove(taskId);
  }

  // Method to set the tasks to a new list
  void setTasks(List<TaskModel> newTasks) {
    // need clarification on this.
  }

  int getTaskIndex(int taskId) {
    for (int i = 0; i < tasks.length; i++) {
      TaskModel task = tasks[i];
      if (task.id == taskId) return i;
    }
    throw Exception("Task $taskId not found in Schedule");
  }

  TaskModel getTaskModel(int taskId) {
    int index = getTaskIndex(taskId);
    return tasks[index];
  }
}

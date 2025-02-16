import 'package:student_75/models/task_model.dart';

class Schedule {
  List<TaskModel> tasks;

  Schedule({required this.tasks});

  // Method to add a task to the schedule
  void add(TaskModel task) {
    //todo add error checking to make sure that task times do not overlap
    tasks.add(task);
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

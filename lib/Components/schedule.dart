import 'package:student_75/models/task_model.dart';

class Schedule {
  List<TaskModel> tasks;

  Schedule({required this.tasks});

  // Method to add a task to the schedule
  void add(TaskModel task) {
    tasks.add(task);
  }

  // Method to remove a task from the schedule by task ID
  void remove(int taskId) {
    tasks.remove(taskId);
  }

  // Method to set the tasks to a new list
  void setTasks(List<TaskModel> newTasks) {
    // need clarification on this.
  }

}

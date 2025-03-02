import 'package:student_75/models/task_model.dart';

abstract class IScheduleManager {
  // ScheduleManager -> GUI methods
  List<TaskModel> getSchedule();
  List<TaskModel> getBacklogSuggestions();
  Future<bool> userBinarySelect(String choice1, String choice2, String message);

  // GUI -> ScheduleManager methods
  void addTask(TaskModel task);
  void deleteTask(int taskId);
  void editTask(TaskModel task);
  void postPoneTask(int taskId);
  void completeTask(int taskId);
  void scheduleBacklogSuggestion(int taskId);
}

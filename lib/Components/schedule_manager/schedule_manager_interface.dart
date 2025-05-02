import 'package:student_75/Components/account_manager/account_manager.dart';
import 'package:student_75/models/task_model.dart';
import 'package:student_75/Components/schedule_manager/schedule.dart';

abstract class IScheduleManager {
  // ScheduleManager -> GUI methods
  Schedule get schedule;
  List<TaskModel> getBacklogSuggestions();
  Future<TaskModel?> userBinarySelect(TaskModel task1, TaskModel task2, String message);
  void displayError(String message);
  AccountManager get accManager;

  // GUI -> ScheduleManager methods
  void addTask(TaskModel task);
  void deleteTask(int taskId);
  void editTask(TaskModel task);
  void postPoneTask(int taskId);
  void completeTask(int taskId);
  void scheduleBacklogSuggestion(int taskId);
  DateTime? findAvailableTimeSlot(TaskModel task);
}

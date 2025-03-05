import 'package:student_75/models/task_model.dart';
import 'package:student_75/Components/schedule_manager/schedule.dart';

abstract class IScheduleManager {
  // ScheduleManager -> GUI methods
  Schedule getSchedule();
  List<TaskModel> getBacklogSuggestions();
  Future<bool> userBinarySelect(String choice1, String choice2, String message);
  void displayError(String message);

  // GUI -> ScheduleManager methods
  void addTask(TaskModel task);
  void deleteTask(int taskId);
  void editTask(TaskModel task);
  void postPoneTask(int taskId);
  void completeTask(int taskId);
  void scheduleBacklogSuggestion(int taskId);
}

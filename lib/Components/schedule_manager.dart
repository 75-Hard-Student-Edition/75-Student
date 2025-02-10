import 'package:student_75/models/task_model.dart';

// Interface for ScheduleManager to interact with the GUI
abstract class IScheduleManager {
  // ScheduleManager -> GUI methods
  Future<List<TaskModel>> getSchedule(DateTime date);
  Future<List<TaskModel>> getBacklogSuggestions();

  // GUI -> ScheduleManager methods
  Future<void> addTask(TaskModel task);
  Future<void> deleteTask(int taskId);
  Future<void> editTask(TaskModel task);
  Future<void> postPoneTask(int taskId);
  Future<List<TaskModel>> scheduleBacklogSuggestion(int taskId);
}
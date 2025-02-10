

class Task { /* Stub implementation of Task */ }

// Interface for ScheduleManager to interact with the GUI
abstract class IScheduleManager {
  // ScheduleManager -> GUI methods
  Future<List<Task>> getSchedule(DateTime date);
  Future<List<Task>> getBacklogSuggestions();

  // GUI -> ScheduleManager methods
  Future<void> addTask(Task task);
  Future<void> deleteTask(int taskId);
  Future<void> editTask(Task task);
  Future<void> postPoneTask(int taskId);
  Future<List<Task>> scheduleBacklogSuggestion(int taskId);
}
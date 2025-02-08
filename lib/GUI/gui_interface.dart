class Task {/* Stub implementation of Task */}

// Interface for GUI to interact with the ScheduleManager
// I.e., GUI -> ScheduleManager methods
abstract class IGUI {
  Future<void> createTask(Task task);
  Future<void> deleteTask(int taskId);
  Future<void> editTask(Task task);
  Future<void> postPoneTask(int taskId);
  Future<List<Task>> scheduleBacklogSuggestion(int taskId);
}

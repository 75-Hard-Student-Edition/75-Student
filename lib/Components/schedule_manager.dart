

class Task { /* Stub implementation of Task */ }

// Interface for ScheduleManager to interact with the GUI
// I.e., ScheduleManager -> GUI methods
abstract class IScheduleManager {
  Future<List<Task>> getSchedule(DateTime date);
  Future<List<Task>> getBacklogSuggestions();
}
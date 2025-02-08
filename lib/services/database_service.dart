class Task {/* Stub implementation of Task */}

class UserAccount {/* Stub implementation of UserAccount */}

abstract class IDatabaseService {
  // ScheduleManager -> Database methods
  Future<void> addTaskRecord(Task task);
  Future<void> updateTaskRecord(Task task);
  Future<void> removeTaskRecord(Task task);

  // Database -> ScheduleManager methods
  Future<Task?> queryTask(int taskId);
  Future<List<Task>> fetchTodaysScheduledTasks();

  // AccountManager -> Database methods
  Future<void> addAccountRecord(UserAccount account);
  Future<void> updateAccountRecord(UserAccount account);
  Future<void> removeAccountRecord(UserAccount account);

  // Database -> AccountManager methods
  Future<UserAccount?> queryAccount(String username);
}

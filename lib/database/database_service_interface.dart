import 'package:student_75/models/task_model.dart';
import 'package:student_75/models/user_account_model.dart';

/*
Contains bi-directional methods due to simplicity of the service, acting simply
as an intermediary layer between the database and business logic.
*/
abstract class IDatabaseService {
  // ScheduleManager -> Database methods
  Future<void> addTaskRecord(TaskModel task, int userId);
  Future<void> updateTaskRecord(TaskModel task, int userId);
  Future<void> removeTaskRecord(int taskId);

  // Database -> ScheduleManager methods
  Future<TaskModel?> queryTask(int taskId);
  Future<List<TaskModel>> fetchTodaysScheduledTasks();

  // AccountManager -> Database methods
  Future<void> addAccountRecord(UserAccountModel account);
  Future<void> updateAccountRecord(UserAccountModel account);
  Future<void> removeAccountRecord(int userId);

  // Database -> AccountManager methods
  Future<UserAccountModel?> queryAccount(String username);
}

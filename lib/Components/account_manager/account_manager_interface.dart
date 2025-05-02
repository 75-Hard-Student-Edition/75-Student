import 'package:student_75/models/difficulty_enum.dart';
import 'package:student_75/models/task_model.dart';
import 'package:student_75/models/user_account_model.dart';

abstract class IAccountManager {
  // AccountManager -> GUI methods
  int getStreak();
  String getUsername();
  Duration getMindfulnessDuration();

  // GUI -> AccountManager methods
  Future<void> createAccount(UserAccountModel userAccount, String password);
  Future<void> deleteAccount(int userId);
  void updateAccount(UserAccountModel userAccount);
  Future<void> login(String username, String password);
  void logout();

  // AccountManager -> Database methods
  void saveUserDetails(UserAccountModel userAccount);

  // AccountManager -> PointsManager methods
  Difficulty getDifficulty();
  List<TaskCategory> getCategoryOrder();

  // PointsManager -> AccountManager methods
  void resetStreak();
  void incrementStreak();

  // AccountManager -> ScheduleManager methods
  int getUserId();
  DateTime getBedtime();
}

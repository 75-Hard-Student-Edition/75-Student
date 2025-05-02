import 'package:student_75/models/difficulty_enum.dart';
import 'package:student_75/models/task_model.dart';
import 'package:student_75/models/user_account_model.dart';

abstract class IAccountManager {
  // AccountManager -> GUI methods
  int getStreak();
  String getUsername();
  Duration getMindfulnessDuration();

  // GUI -> AccountManager methods
  void createAccount(UserAccountModel userAccount);
  void deleteAccount(int userId);
  void updateAccount(UserAccountModel userAccount);
  void login(String username, String password);
  void logout();

  // AccountManager -> Database methods
  void saveUserDetails(UserAccountModel userAccount);

  // Database -> AccountManager methods
  UserAccountModel fetchUserDetails(int userId);

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

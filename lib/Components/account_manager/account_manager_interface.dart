import 'package:flutter/material.dart';
import 'package:student_75/models/difficulty_enum.dart';
import 'package:student_75/models/user_account_model.dart';

abstract class IAccountManager {
  // AccountManager -> GUI methods
  int getStreak();
  String getUsername();

  // GUI -> AccountManager methods
  void createAccount(UserAccountModel userAccount);
  void deleteAccount(int userId);
  void updateAccount(UserAccountModel userAccount);
  void login(String username, String password);
  void logout();

  // AccountManager -> Database methods
  void saveUserDetails(UserAccountModel userAccount);

  // Database -> AccountManager methods
  UserAccountModel loadUserDetails(int userId);

  // AccountManager -> PointsManager methods
  Difficulty getDifficulty();

  // PointsManager -> AccountManager methods
  void resetStreak();
  void incrementStreak();

  // AccountManager -> ScheduleManager methods
  int getUserId();
  TimeOfDay getBedtime();
}

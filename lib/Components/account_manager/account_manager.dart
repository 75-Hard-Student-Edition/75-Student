import 'package:flutter/material.dart';
import 'package:student_75/Components/account_manager/account_manager_interface.dart';
import 'package:student_75/models/difficulty_enum.dart';
import 'package:student_75/models/user_account_model.dart';

class NoUserSignedInException implements Exception {
  final String message;
  NoUserSignedInException(this.message);

  @override
  String toString() => 'NoUserSignedInException: $message';
}

class AccountManager implements IAccountManager {
  UserAccountModel? userAccount;

  //* AccountManager -> GUI methods
  @override
  int getStreak() {
    if (userAccount == null) throw NoUserSignedInException('No user signed in');
    return userAccount!.streak;
  }

  @override
  String getUsername() {
    if (userAccount == null) throw NoUserSignedInException('No user signed in');
    return userAccount!.username;
  }

  //* GUI -> AccountManager methods
  @override
  void login(String username, String password) {
    //todo fetch account details from database
    UserAccountModel fetchFromDb = UserAccountModel(
      id: 0,
      username: username,
      difficulty: Difficulty.easy,
      categoryOrder: [],
      sleepDuration: const Duration(hours: 8),
      bedtimes: {},
      bedtimeNotifyBefore: const Duration(minutes: 30),
    );
    userAccount = fetchFromDb;
  }

  @override
  void logout() => userAccount = null;

  @override
  void createAccount(UserAccountModel account) {
    //todo save account details to database
  }

  @override
  void deleteAccount(int userId) {
    //todo delete account details from database
  }

  @override
  void updateAccount(UserAccountModel newAccount) {
    // Use the copyWith method to update the account details
    //todo update account details in database
  }

  //* AccountManager -> Database methods
  @override
  void saveUserDetails(UserAccountModel userAccount) {
    //todo save account details to database
  }

  //* Database -> AccountManager methods
  @override
  UserAccountModel fetchUserDetails(int userId) {
    //todo fetch account details from database
    return UserAccountModel(
      id: 0,
      username: 'Stub User',
      difficulty: Difficulty.easy,
      categoryOrder: [],
      sleepDuration: const Duration(hours: 8),
      bedtimes: {},
      bedtimeNotifyBefore: const Duration(minutes: 30),
    );
  }

  //* AccountManager -> PointsManager methods
  @override
  Difficulty getDifficulty() {
    if (userAccount == null) throw NoUserSignedInException('No user signed in');
    return userAccount!.difficulty;
  }

  //* PointsManager -> AccountManager methods
  @override
  void resetStreak() {
    if (userAccount == null) throw NoUserSignedInException('No user signed in');
    userAccount = userAccount!.copyWith(streak: 0);
  }

  @override
  void incrementStreak() {
    if (userAccount == null) throw NoUserSignedInException('No user signed in');
    userAccount = userAccount!.copyWith(streak: userAccount!.streak + 1);
  }

  //* AccountManager -> ScheduleManager methods
  @override
  int getUserId() {
    if (userAccount == null) throw NoUserSignedInException('No user signed in');
    return userAccount!.id;
  }

  @override
  TimeOfDay getBedtime() {
    if (userAccount == null) throw NoUserSignedInException('No user signed in');
    final int dayIndex = DateTime.now().weekday;
    final String day =
        ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'][dayIndex];
    return userAccount!.bedtimes[day]!;
  }
}

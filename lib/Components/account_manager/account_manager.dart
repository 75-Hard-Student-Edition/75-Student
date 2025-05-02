import 'package:student_75/Components/account_manager/account_manager_interface.dart';
import 'package:student_75/models/difficulty_enum.dart';
import 'package:student_75/models/user_account_model.dart';
import 'package:student_75/models/task_model.dart';
import 'package:student_75/database/database_service.dart';

class NoUserSignedInException implements Exception {
  final String message;
  NoUserSignedInException(this.message);

  @override
  String toString() => 'NoUserSignedInException: $message';
}

class AccountNotFoundException implements Exception {
  final String message;
  AccountNotFoundException(this.message);

  @override
  String toString() => 'AccountNotFoundException: $message';
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
  Future<void> login(String username, String password) async {
    UserAccountModel? fetchedAccount = await DatabaseService().queryAccount(username, password);
    if (fetchedAccount == null) {
      throw AccountNotFoundException(
          'Account with that password not found for username: $username');
    }
    userAccount = fetchedAccount;
  }

  @override
  void logout() => userAccount = null;

  @override
  Future<void> createAccount(UserAccountModel account, String password) async {
    await DatabaseService().addAccountRecord(account);
    userAccount = account; // Login the user after creating the account
  }

  @override
  Future<void> deleteAccount(int userId) async {
    await DatabaseService().removeAccountRecord(userId);
    userAccount = null; // Logout the user after deleting the account
  }

  @override
  void updateAccount(UserAccountModel newAccount) {
    // Use the copyWith method to update the account details
    userAccount = newAccount;
    saveUserDetails(userAccount!);
  }

  //* AccountManager -> Database methods
  @override
  Future<void> saveUserDetails(UserAccountModel userAccount) async =>
      await DatabaseService().updateAccountRecord(userAccount);

  //* AccountManager -> PointsManager methods
  @override
  Difficulty getDifficulty() {
    if (userAccount == null) throw NoUserSignedInException('No user signed in');
    if (userAccount!.difficulty == null) {
      throw NoUserSignedInException('No difficulty set for user');
    }
    return userAccount!.difficulty!;
  }

  @override
  List<TaskCategory> getCategoryOrder() {
    if (userAccount == null) throw NoUserSignedInException('No user signed in');
    if (userAccount!.categoryOrder == null) {
      throw NoUserSignedInException('No category order set for user');
    }
    return userAccount!.categoryOrder!;
  }

  @override
  Duration getMindfulnessDuration() {
    if (userAccount == null) throw NoUserSignedInException('No user signed in');
    if (userAccount!.mindfulnessDuration == null) {
      throw NoUserSignedInException('No mindfulness duration set for user');
    }
    return userAccount!.mindfulnessDuration!;
  }

  //* PointsManager -> AccountManager methods
  @override
  void resetStreak() {
    if (userAccount == null) throw NoUserSignedInException('No user signed in');
    userAccount = userAccount!.copyWith(streak: 0);
    saveUserDetails(userAccount!);
  }

  @override
  void incrementStreak() {
    if (userAccount == null) throw NoUserSignedInException('No user signed in');
    int newStreak = getStreak() + 1;
    userAccount = userAccount!.copyWith(streak: newStreak);
    saveUserDetails(userAccount!);
  }

  //* AccountManager -> ScheduleManager methods
  @override
  int getUserId() {
    if (userAccount == null) throw NoUserSignedInException('No user signed in');
    return userAccount!.id;
  }

  @override
  DateTime getBedtime() {
    if (userAccount == null) throw NoUserSignedInException('No user signed in');
    if (userAccount!.bedtime == null) {
      throw NoUserSignedInException('No bedtimes set for user');
    }
    return userAccount!.bedtime!;
  }
}

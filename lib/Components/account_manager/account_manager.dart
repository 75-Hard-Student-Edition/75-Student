import 'package:student_75/Components/account_manager/account_manager_interface.dart';
import 'package:student_75/models/difficulty_enum.dart';
import 'package:student_75/models/user_account_model.dart';
import 'package:student_75/models/task_model.dart';

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
      streak: 0,
      difficulty: Difficulty.easy,
      categoryOrder: [
        TaskCategory.academic,
        TaskCategory.chore,
        TaskCategory.employment,
        TaskCategory.health,
        TaskCategory.hobby,
        TaskCategory.social
      ],
      sleepDuration: const Duration(hours: 8),
      bedtime: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 22, 0),
      bedtimeNotifyBefore: const Duration(minutes: 30),
      mindfulnessDuration: const Duration(minutes: 10),
    );
    userAccount = fetchFromDb;
  }

  @override
  void logout() => userAccount = null;

  @override
  void createAccount(UserAccountModel account) {
    //todo save account details to database
    //! temporary stub login because database is not implemented yet
    userAccount =
        account; // Once db is implemented, login() should be called after this method
  }

  @override
  void deleteAccount(int userId) {
    //todo delete account details from database
  }

  @override
  void updateAccount(UserAccountModel newAccount) {
    // Use the copyWith method to update the account details
    userAccount = newAccount;
    saveUserDetails(userAccount!);
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
      streak: 0,
      difficulty: Difficulty.easy,
      categoryOrder: [],
      sleepDuration: const Duration(hours: 8),
      bedtime: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 22, 0),
      bedtimeNotifyBefore: const Duration(minutes: 30),
      mindfulnessDuration: const Duration(minutes: 10),
    );
  }

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
  }

  @override
  void incrementStreak() {
    if (userAccount == null) throw NoUserSignedInException('No user signed in');
    int newStreak = getStreak() + 1;
    userAccount = userAccount!.copyWith(streak: newStreak);
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

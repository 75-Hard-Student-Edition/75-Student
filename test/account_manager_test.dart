import 'package:flutter_test/flutter_test.dart';
import 'package:student_75/Components/account_manager/account_manager.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:student_75/models/user_account_model.dart';
import 'package:student_75/models/difficulty_enum.dart';
import 'package:student_75/models/task_model.dart';

void main() {
  group('AccountManager Tests', () {
    late AccountManager accountManager;
    TestWidgetsFlutterBinding.ensureInitialized();
    databaseFactory = databaseFactoryFfi;

    setUp(() {
      accountManager = AccountManager();
    });

    // Test for getStreak()
    test('getStreak() should return the correct streak', () async {
      accountManager.userAccount = UserAccountModel(
        id: 1,
        username: 'testuser',
        streak: 5,
        difficulty: Difficulty.medium,
        categoryOrder: [
          TaskCategory.academic,
          TaskCategory.social,
          TaskCategory.health,
          TaskCategory.hobby,
          TaskCategory.chore,
          TaskCategory.hobby,
          TaskCategory.employment
        ],
        sleepDuration: Duration(hours: 8),
        bedtime: DateTime.now(),
        bedtimeNotifyBefore: Duration(minutes: 30),
        mindfulnessDuration: Duration(minutes: 10),
      );

      expect(accountManager.getStreak(), equals(5));
    });

    test('getStreak() should throw NoUserSignedInException when no user is signed in', () {
      expect(() => accountManager.getStreak(), throwsA(isA<NoUserSignedInException>()));
    });

    // Test for getUsername()
    test('getUsername() should return the correct username', () async {
      accountManager.userAccount = UserAccountModel(
        id: 1,
        username: 'testuser',
        streak: 5,
        difficulty: Difficulty.medium,
        categoryOrder: [
          TaskCategory.academic,
          TaskCategory.social,
          TaskCategory.health,
          TaskCategory.hobby,
          TaskCategory.chore,
          TaskCategory.hobby,
          TaskCategory.employment
        ],
        sleepDuration: Duration(hours: 8),
        bedtime: DateTime.now(),
        bedtimeNotifyBefore: Duration(minutes: 30),
        mindfulnessDuration: Duration(minutes: 10),
      );

      expect(accountManager.getUsername(), equals('testuser'));
    });

    test('getUsername() should throw NoUserSignedInException when no user is signed in', () {
      expect(() => accountManager.getUsername(), throwsA(isA<NoUserSignedInException>()));
    });

    // Test for createAccount()
    test('createAccount() should create an account and sign in the user', () async {
      final userAccount = UserAccountModel(
        id: 1,
        username: 'newuser',
        streak: 0,
        difficulty: Difficulty.easy,
        categoryOrder: [
          TaskCategory.academic,
          TaskCategory.social,
          TaskCategory.health,
          TaskCategory.hobby,
          TaskCategory.chore,
          TaskCategory.hobby,
          TaskCategory.employment
        ],
        sleepDuration: Duration(hours: 8),
        bedtime: DateTime.now(),
        bedtimeNotifyBefore: Duration(minutes: 30),
        mindfulnessDuration: Duration(minutes: 10),
      );

      await accountManager.createAccount(userAccount, 'password123');
      expect(accountManager.userAccount, equals(userAccount));
    });

    test('createAccount() should throw an error if account already exists', () async {
      final userAccount = UserAccountModel(
        id: 1,
        username: 'existinguser',
        streak: 0,
        difficulty: Difficulty.easy,
        categoryOrder: [
          TaskCategory.academic,
          TaskCategory.social,
          TaskCategory.health,
          TaskCategory.hobby,
          TaskCategory.chore,
          TaskCategory.hobby,
          TaskCategory.employment
        ],
        sleepDuration: Duration(hours: 8),
        bedtime: DateTime.now(),
        bedtimeNotifyBefore: Duration(minutes: 30),
        mindfulnessDuration: Duration(minutes: 10),
      );

      await accountManager.createAccount(userAccount, 'password123');
      expect(() => accountManager.createAccount(userAccount, 'newpassword123'),
          throwsA(isA<Exception>()));
    });

    // Test for login()
    test('login() should login the user successfully', () async {
      final userAccount = UserAccountModel(
        id: 1,
        username: 'validuser',
        streak: 3,
        difficulty: Difficulty.medium,
        categoryOrder: [
          TaskCategory.academic,
          TaskCategory.social,
          TaskCategory.health,
          TaskCategory.hobby,
          TaskCategory.chore,
          TaskCategory.hobby,
          TaskCategory.employment
        ],
        sleepDuration: Duration(hours: 8),
        bedtime: DateTime.now(),
        bedtimeNotifyBefore: Duration(minutes: 30),
        mindfulnessDuration: Duration(minutes: 10),
      );

      await accountManager.createAccount(userAccount, 'validpassword');
      await accountManager.login('validuser', 'validpassword');

      expect(accountManager.userAccount, equals(userAccount));
    });

    test('login() should throw AccountNotFoundException if invalid credentials are provided',
        () async {
      await accountManager.createAccount(
          UserAccountModel(
            id: 1,
            username: 'validuser',
            streak: 3,
            difficulty: Difficulty.medium,
            categoryOrder: [
              TaskCategory.academic,
              TaskCategory.social,
              TaskCategory.health,
              TaskCategory.hobby,
              TaskCategory.chore,
              TaskCategory.hobby,
              TaskCategory.employment
            ],
            sleepDuration: Duration(hours: 8),
            bedtime: DateTime.now(),
            bedtimeNotifyBefore: Duration(minutes: 30),
            mindfulnessDuration: Duration(minutes: 10),
          ),
          'validpassword');

      expect(() => accountManager.login('validuser', 'invalidpassword'),
          throwsA(isA<AccountNotFoundException>()));
    });

    // Test for logout()
    test('logout() should log the user out', () async {
      final userAccount = UserAccountModel(
        id: 1,
        username: 'testuser',
        streak: 5,
        difficulty: Difficulty.medium,
        categoryOrder: [
          TaskCategory.academic,
          TaskCategory.social,
          TaskCategory.health,
          TaskCategory.hobby,
          TaskCategory.chore,
          TaskCategory.hobby,
          TaskCategory.employment
        ],
        sleepDuration: Duration(hours: 8),
        bedtime: DateTime.now(),
        bedtimeNotifyBefore: Duration(minutes: 30),
        mindfulnessDuration: Duration(minutes: 10),
      );

      await accountManager.createAccount(userAccount, 'password123');
      accountManager.logout();

      expect(accountManager.userAccount, isNull);
    });

    // Test for difficulty
    test('getDifficulty() should throw if difficulty is not set', () {
  accountManager.userAccount = UserAccountModel(
    id: 1,
    username: 'testuser',
    streak: 0,
    difficulty: null,
    categoryOrder: [],
    sleepDuration: Duration(hours: 8),
    bedtime: DateTime.now(),
    bedtimeNotifyBefore: Duration(minutes: 30),
    mindfulnessDuration: Duration(minutes: 10),
  );
  expect(() => accountManager.getDifficulty(), throwsA(isA<NoUserSignedInException>()));
});

  // Test Category Order
  test('getCategoryOrder() should throw if categoryOrder is not set', () {
    accountManager.userAccount = UserAccountModel(
      id: 1,
      username: 'testuser',
      streak: 0,
      difficulty: Difficulty.medium,
      categoryOrder: null,
      sleepDuration: Duration(hours: 8),
      bedtime: DateTime.now(),
      bedtimeNotifyBefore: Duration(minutes: 30),
      mindfulnessDuration: Duration(minutes: 10),
    );

    expect(() => accountManager.getCategoryOrder(),
        throwsA(isA<NoUserSignedInException>()));
  });

    // Test for deleteAccount()
    test('deleteAccount() should delete the user account and log the user out', () async {
      final userAccount = UserAccountModel(
        id: 1,
        username: 'testuser',
        streak: 5,
        difficulty: Difficulty.medium,
        categoryOrder: [
          TaskCategory.academic,
          TaskCategory.social,
          TaskCategory.health,
          TaskCategory.hobby,
          TaskCategory.chore,
          TaskCategory.hobby,
          TaskCategory.employment
        ],
        sleepDuration: Duration(hours: 8),
        bedtime: DateTime.now(),
        bedtimeNotifyBefore: Duration(minutes: 30),
        mindfulnessDuration: Duration(minutes: 10),
      );

      await accountManager.createAccount(userAccount, 'password123');
      await accountManager.deleteAccount(1);

      expect(accountManager.userAccount, isNull);
    });

    // Test for resetStreak()
    test('resetStreak() should reset the streak to 0', () async {
      final userAccount = UserAccountModel(
        id: 1,
        username: 'testuser',
        streak: 10,
        difficulty: Difficulty.medium,
        categoryOrder: [
          TaskCategory.academic,
          TaskCategory.social,
          TaskCategory.health,
          TaskCategory.hobby,
          TaskCategory.chore,
          TaskCategory.hobby,
          TaskCategory.employment
        ],
        sleepDuration: Duration(hours: 8),
        bedtime: DateTime.now(),
        bedtimeNotifyBefore: Duration(minutes: 30),
        mindfulnessDuration: Duration(minutes: 10),
      );

      await accountManager.createAccount(userAccount, 'password123');
      accountManager.resetStreak();

      expect(accountManager.getStreak(), equals(0));
    });

    // Test for incrementStreak()
    test('incrementStreak() should increment the streak by 1', () async {
      final userAccount = UserAccountModel(
        id: 1,
        username: 'testuser',
        streak: 5,
        difficulty: Difficulty.medium,
        categoryOrder: [
          TaskCategory.academic,
          TaskCategory.social,
          TaskCategory.health,
          TaskCategory.hobby,
          TaskCategory.chore,
          TaskCategory.hobby,
          TaskCategory.employment
        ],
        sleepDuration: Duration(hours: 8),
        bedtime: DateTime.now(),
        bedtimeNotifyBefore: Duration(minutes: 30),
        mindfulnessDuration: Duration(minutes: 10),
      );

      await accountManager.createAccount(userAccount, 'password123');
      accountManager.incrementStreak();

      expect(accountManager.getStreak(), equals(6));
    });

    // Test for updateAccount()
    test('updateAccount() should update the user account details', () async {
      final userAccount = UserAccountModel(
        id: 1,
        username: 'testuser',
        streak: 5,
        difficulty: Difficulty.medium,
        categoryOrder: [
          TaskCategory.academic,
          TaskCategory.social,
          TaskCategory.health,
          TaskCategory.hobby,
          TaskCategory.chore,
          TaskCategory.hobby,
          TaskCategory.employment
        ],
        sleepDuration: Duration(hours: 8),
        bedtime: DateTime.now(),
        bedtimeNotifyBefore: Duration(minutes: 30),
        mindfulnessDuration: Duration(minutes: 10),
      );

      await accountManager.createAccount(userAccount, 'password123');
      final updatedAccount = userAccount.copyWith(streak: 10, username: 'updateduser');
      accountManager.updateAccount(updatedAccount);

      expect(accountManager.getStreak(), equals(10));
      expect(accountManager.getUsername(), equals('updateduser'));
    });
  });
}

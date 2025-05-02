import 'package:flutter_test/flutter_test.dart';
import 'package:student_75/models/user_account_model.dart';
import 'package:student_75/models/difficulty_enum.dart';
import 'package:student_75/models/task_model.dart';
import 'package:student_75/Components/account_manager/account_manager.dart';

void main() {
  late AccountManager accountManager;

  setUp(() {
    // Initialize AccountManager before each test
    accountManager = AccountManager();
  });

  group('AccountManager Tests', () {
    test('Login and Get Username', () {
      accountManager.login('testuser', 'password');
      expect(accountManager.getUsername(), 'testuser');
    });

    test('Get Streak', () {
      accountManager.login('testuser', 'password');
      expect(accountManager.getStreak(), 0);
    });

    test('Get Difficulty', () {
      accountManager.login('testuser', 'password');
      expect(accountManager.getDifficulty(), Difficulty.easy);
    });

    test('Get Category Order', () {
      accountManager.login('testuser', 'password');
      expect(accountManager.getCategoryOrder(), isNotEmpty);
      expect(accountManager.getCategoryOrder().first, TaskCategory.academic);
    });

    test('Get Mindfulness Duration', () {
      accountManager.login('testuser', 'password');
      expect(
          accountManager.getMindfulnessDuration(), const Duration(minutes: 30));
    });

    test('Reset Streak', () {
      accountManager.login('testuser', 'password');
      accountManager.incrementStreak();
      accountManager.resetStreak();
      expect(accountManager.getStreak(), 0);
    });

    test('Increment Streak', () {
      accountManager.login('testuser', 'password');
      print(accountManager.getStreak());
      accountManager
          .incrementStreak(); // need to check incrementStreak in the account manager. Test failed.
      print(accountManager.getStreak());
      expect(accountManager.getStreak(), 1);
    });

    test('Update Account', () {
      accountManager.login('testuser', 'password');
      final updatedAccount = UserAccountModel(
        id: 1,
        username: 'updateduser',
        difficulty: Difficulty.medium,
        categoryOrder: [TaskCategory.social, TaskCategory.hobby],
        sleepDuration: const Duration(hours: 7),
        bedtime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 22, 30),
        bedtimeNotifyBefore: const Duration(minutes: 20),
        mindfulnessDuration: const Duration(minutes: 15),
      );
      accountManager.updateAccount(updatedAccount);
      expect(accountManager.getUsername(), 'updateduser');
      expect(accountManager.getDifficulty(), Difficulty.medium);
    });

    test('Logout', () {
      accountManager.login('testuser', 'password');
      accountManager.logout();
      expect(() => accountManager.getUsername(),
          throwsA(isA<NoUserSignedInException>()));
    });
  });
}

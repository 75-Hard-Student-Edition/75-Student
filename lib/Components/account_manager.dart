import 'package:student_75/models/user_account_model.dart';

abstract class IAccountManager {
  Future<void> createAccount(UserAccountModel account);
  Future<void> deleteAccount(String username);
  Future<void> login(String username, String password);
  Future<void> logout();
}

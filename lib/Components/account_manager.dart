class UserAccount {/* Stub implementation of UserAccount */}

abstract class IAccountManager {
  Future<void> createAccount(UserAccount account);
  Future<void> deleteAccount(String username);
  Future<void> login(String username, String password);
  Future<void> logout();
}

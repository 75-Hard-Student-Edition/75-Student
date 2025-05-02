import 'package:student_75/models/user_account_model.dart';

extension UserAccountModelDB on UserAccountModel {
  Map<String, dynamic> toMap() {
    return {
      "user_id": id,
      "username": username,
      "streak": streak,
    };
  }
}

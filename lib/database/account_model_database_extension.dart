import 'package:student_75/models/user_account_model.dart';
import 'package:student_75/models/difficulty_enum.dart';

extension UserAccountModelDB on UserAccountModel {
  Map<String, dynamic> toMap() {
    return {
      "user_id": id,
      "username": username,
      "streak": streak,
      "email": email ?? "",
      "phone_number": phoneNumber ?? "",
      "difficulty": Difficulty.values.indexOf(difficulty!),
      "category_order": categoryOrder.toString(),
      "sleep_duration_minutes": sleepDuration!.inMinutes,
      "bedtime": bedtime!.toIso8601String(),
      "notify_time_minutes": bedtimeNotifyBefore,
      "mindfulness_minutes": mindfulnessDuration!.inMinutes,
    };
  }
}

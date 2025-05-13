import 'package:student_75/models/difficulty_enum.dart';
import 'package:student_75/models/task_model.dart';
import 'package:collection/collection.dart';

class UserAccountModel {
  final int id;
  final String username;
  final String? email;
  final String? phoneNumber;
  final int streak;
  final Difficulty? difficulty;
  final List<TaskCategory>? categoryOrder;
  final Duration? sleepDuration;
  final DateTime? bedtime;
  final Duration?
      bedtimeNotifyBefore; //! Should be "notifyBefore". Remember to update DB models if you change this
  final Duration? mindfulnessDuration;
  UserAccountModel({
    required this.id,
    required this.username,
    this.email,
    this.phoneNumber,
    required this.streak,
    required this.difficulty,
    required this.categoryOrder,
    required this.sleepDuration,
    required this.bedtime,
    required this.bedtimeNotifyBefore,
    required this.mindfulnessDuration,
  });

  UserAccountModel copyWith({
    int? id,
    String? username,
    String? email,
    String? phoneNumber,
    int? streak,
    Difficulty? difficulty,
    List<TaskCategory>? categoryOrder,
    Duration? sleepDuration,
    DateTime? bedtime,
    Duration? bedtimeNotifyBefore,
    Duration? mindfulnessDuration,
  }) {
    return UserAccountModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      streak: streak ?? this.streak,
      difficulty: difficulty ?? this.difficulty,
      categoryOrder: categoryOrder ?? this.categoryOrder,
      sleepDuration: sleepDuration ?? this.sleepDuration,
      bedtime: bedtime ?? this.bedtime,
      bedtimeNotifyBefore: bedtimeNotifyBefore ?? this.bedtimeNotifyBefore,
      mindfulnessDuration: mindfulnessDuration ?? this.mindfulnessDuration,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAccountModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          username == other.username &&
          email == other.email &&
          phoneNumber == other.phoneNumber &&
          streak == other.streak &&
          difficulty == other.difficulty &&
          const ListEquality().equals(categoryOrder, other.categoryOrder) &&
          sleepDuration == other.sleepDuration &&
          ((bedtime == null && other.bedtime == null) ||
              (bedtime != null &&
                  other.bedtime != null &&
                  bedtime!.isAtSameMomentAs(other.bedtime!))) &&
          bedtimeNotifyBefore == other.bedtimeNotifyBefore &&
          mindfulnessDuration == other.mindfulnessDuration;

  @override
  int get hashCode =>
      id.hashCode ^
      username.hashCode ^
      email.hashCode ^
      phoneNumber.hashCode ^
      streak.hashCode ^
      difficulty.hashCode ^
      const ListEquality().hash(categoryOrder) ^
      sleepDuration.hashCode ^
      (bedtime?.millisecondsSinceEpoch.hashCode ?? 0) ^
      bedtimeNotifyBefore.hashCode ^
      mindfulnessDuration.hashCode;

  @override
  String toString() {
    return 'UserAccountModel{id: $id, username: $username, difficulty: $difficulty, categoryOrder: $categoryOrder, sleepDuration: $sleepDuration, bedtime: $bedtime, bedtimeNotifyBefore: $bedtimeNotifyBefore, mindfulnessDuration: $mindfulnessDuration}';
  }
}

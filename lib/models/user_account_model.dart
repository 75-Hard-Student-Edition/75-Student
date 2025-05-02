import 'package:flutter/material.dart'; // TimeOfDay
import 'package:student_75/models/difficulty_enum.dart';
import 'package:student_75/models/task_model.dart';

class UserAccountModel {
  final int id;
  final String username;
  final String? email;
  final String? phoneNumber;
  final int streak = 0;
  final Difficulty? difficulty;
  final List<TaskCategory>? categoryOrder;
  final Duration? sleepDuration;
  final TimeOfDay? bedtime;
  final Duration? bedtimeNotifyBefore; //! Should be "notifyBefore"
  final Duration? mindfulnessDuration;

  UserAccountModel({
    required this.id,
    required this.username,
    this.email,
    this.phoneNumber,
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
    TimeOfDay? bedtime,
    Duration? bedtimeNotifyBefore,
    Duration? mindfulnessDuration,
  }) {
    return UserAccountModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      difficulty: difficulty ?? this.difficulty,
      categoryOrder: categoryOrder ?? this.categoryOrder,
      sleepDuration: sleepDuration ?? this.sleepDuration,
      bedtime: bedtime ?? this.bedtime,
      bedtimeNotifyBefore: bedtimeNotifyBefore ?? this.bedtimeNotifyBefore,
      mindfulnessDuration: mindfulnessDuration ?? this.mindfulnessDuration,
    );
  }

  @override
  String toString() {
    return 'UserAccountModel{id: $id, username: $username, difficulty: $difficulty, categoryOrder: $categoryOrder, sleepDuration: $sleepDuration, bedtime: $bedtime, bedtimeNotifyBefore: $bedtimeNotifyBefore, mindfulnessDuration: $mindfulnessDuration}';
  }
}

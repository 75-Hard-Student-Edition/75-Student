import 'package:flutter/material.dart'; // TimeOfDay
import 'package:student_75/models/difficulty_enum.dart';
import 'package:student_75/models/task_model.dart';

class UserAccountModel {
  final int id;
  final String username;
  final int streak = 0;
  final Difficulty? difficulty;
  final List<TaskCategory>? categoryOrder;
  final Duration? sleepDuration;
  final Map<String, TimeOfDay>? bedtimes;
  final Duration? bedtimeNotifyBefore;
  final Duration? mindfulnessDuration;

  UserAccountModel({
    required this.id,
    required this.username,
    required this.difficulty,
    required this.categoryOrder,
    required this.sleepDuration,
    required this.bedtimes,
    required this.bedtimeNotifyBefore,
    required this.mindfulnessDuration,
  });

  UserAccountModel copyWith({
    int? id,
    String? username,
    int? streak,
    Difficulty? difficulty,
    List<TaskCategory>? categoryOrder,
    Duration? sleepDuration,
    Map<String, TimeOfDay>? bedtimes,
    Duration? bedtimeNotifyBefore,
    Duration? mindfulnessDuration,
  }) {
    return UserAccountModel(
      id: id ?? this.id,
      username: username ?? this.username,
      difficulty: difficulty ?? this.difficulty,
      categoryOrder: categoryOrder ?? this.categoryOrder,
      sleepDuration: sleepDuration ?? this.sleepDuration,
      bedtimes: bedtimes ?? this.bedtimes,
      bedtimeNotifyBefore: bedtimeNotifyBefore ?? this.bedtimeNotifyBefore,
      mindfulnessDuration: mindfulnessDuration ?? this.mindfulnessDuration,
    );
  }

  @override
  String toString() {
    return 'UserAccountModel{id: $id, username: $username, difficulty: $difficulty, categoryOrder: $categoryOrder, sleepDuration: $sleepDuration, bedtimes: $bedtimes, bedtimeNotifyBefore: $bedtimeNotifyBefore, mindfulnessDuration: $mindfulnessDuration}';
  }
}

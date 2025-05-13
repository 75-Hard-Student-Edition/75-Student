import 'package:flutter_test/flutter_test.dart';
import 'package:test/test.dart' as coreTest;
import 'package:student_75/Components/schedule_manager/schedule_manager.dart';
import 'package:student_75/Components/schedule_manager/schedule_generator.dart';
import 'package:student_75/models/task_model.dart';
import 'package:student_75/models/difficulty_enum.dart';
import 'package:student_75/models/user_account_model.dart';
import 'package:student_75/Components/account_manager/account_manager.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';



void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ScheduleManager scheduleManager;
  late TaskModel task1;
  late TaskModel task2;

  setUp(() async {
    databaseFactory = databaseFactoryFfi;
  });

  tearDown(() async {
    await scheduleManager.close();
  });

  group('TaskModel Tests' () {
    coreTest.test('')
  });
}
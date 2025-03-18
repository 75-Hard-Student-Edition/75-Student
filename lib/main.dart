import 'package:student_75/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:student_75/userInterfaces/category_ranking.dart';
import 'package:student_75/models/task_model.dart';
import 'package:student_75/Components/schedule_manager/schedule.dart';

Future<void> main() async {
  // Ensure that the Flutter binding is initialized before calling any plugins
  WidgetsFlutterBinding.ensureInitialized();

  // Load the app settings
  // await AppSettings.loadSettings();


  runApp(
    const MyApp(),
    /*ChangeNotifierProvider(
      create: (context) => Schedule(),
      child: const MyApp(),
    ),*/
  );
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo Not Loading',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: CategoryRankingScreen(),
    );
  }
}

/*
Flow of pages
1. Start Up -> 2. Sign Up/ Log In -> 3. Difficulty Page -> 4.Category Organisation -> 
5. Home Page -> BottomNav

Bottom Nav:
5. Home // 6. Profile // 7. Add // 8. Settings // 9. Mindfulness 
*/

//todo: 1, 2, 3, 4, 6, 7, 8, 9
//! bottom nav pages and 3. need to be done before 1 and 2


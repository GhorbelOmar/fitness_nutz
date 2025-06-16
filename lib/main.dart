import 'package:flutter/material.dart';
import 'pages/exercise_list_page.dart';
import 'pages/exercise_form_page.dart';
import 'pages/workout_list_page.dart';
import 'pages/workout_form_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: ExerciseListPage.routeName,
      routes: {
        ExerciseListPage.routeName: (_) => ExerciseListPage(),
        ExerciseFormPage.routeName: (_) => ExerciseFormPage(),
        WorkoutListPage.routeName: (_) => WorkoutListPage(),
        WorkoutFormPage.routeName: (_) => WorkoutFormPage(),
      },
    );
  }
}

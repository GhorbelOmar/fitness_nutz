import 'package:flutter/material.dart';
import 'workout_form_page.dart';

class WorkoutListPage extends StatelessWidget {
  static const routeName = '/workouts';

  const WorkoutListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: load workouts from DB
    return Scaffold(
      appBar: AppBar(title: Text('Workouts')),
      body: ListView(
        children: [
          // List of workouts
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.pushNamed(context, WorkoutFormPage.routeName),
        child: Icon(Icons.add),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'exercise_form_page.dart';

class ExerciseListPage extends StatelessWidget {
  static const routeName = '/exercises';

  const ExerciseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: load list from DB
    return Scaffold(
      appBar: AppBar(title: Text('Exercises')),
      body: ListView(
        children: [
          // List of exercises
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.pushNamed(context, ExerciseFormPage.routeName),
        child: Icon(Icons.add),
      ),
    );
  }
}

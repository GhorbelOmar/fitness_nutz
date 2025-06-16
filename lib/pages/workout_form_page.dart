import 'package:flutter/material.dart';

class WorkoutFormPage extends StatefulWidget {
  static const routeName = '/workout_form';

  const WorkoutFormPage({super.key});
  @override
  _WorkoutFormPageState createState() => _WorkoutFormPageState();
}

class _WorkoutFormPageState extends State<WorkoutFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _note = '';
  final List<int> _selectedExerciseIds = [];
  final Map<int, List<ExerciseSetInput>> _setsForExercise = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add / Edit Workout')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Workout Name'),
                    onSaved: (v) => _name = v ?? '',
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Note'),
                    onSaved: (v) => _note = v ?? '',
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Select Exercises',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  // TODO: load and display checkboxes for each existing exercise
                  ..._selectedExerciseIds.map((id) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Exercise \$id'),
                        ..._setsForExercise[id]?.map(
                              (esi) => esi.build(context),
                            ) ??
                            [],
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _setsForExercise
                                  .putIfAbsent(id, () => [])
                                  .add(ExerciseSetInput());
                            });
                          },
                          child: Text('Add Set'),
                        ),
                      ],
                    );
                  }),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _formKey.currentState?.save();
                      // TODO: save workout with sets
                      Navigator.pop(context);
                    },
                    child: Text('Save Workout'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciseSetInput {
  int reps = 0;
  double weight = 0;
  bool working = false;
  String note = '';

  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Reps'),
              keyboardType: TextInputType.number,
              onSaved: (v) => reps = int.tryParse(v ?? '') ?? 0,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Weight'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onSaved: (v) => weight = double.tryParse(v ?? '') ?? 0,
            ),
            SwitchListTile(
              title: Text('Working Set'),
              value: working,
              onChanged: (v) => working = v,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Note'),
              onSaved: (v) => note = v ?? '',
            ),
          ],
        ),
      ),
    );
  }
}

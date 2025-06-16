import 'package:flutter/material.dart';

class ExerciseFormPage extends StatefulWidget {
  static const routeName = '/exercise_form';

  const ExerciseFormPage({super.key});

  @override
  _ExerciseFormPageState createState() => _ExerciseFormPageState();
}

class _ExerciseFormPageState extends State<ExerciseFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _note = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add / Edit Exercise')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                onSaved: (v) => _name = v ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Note'),
                onSaved: (v) => _note = v ?? '',
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _formKey.currentState?.save();
                  // TODO: save to DB
                  Navigator.pop(context);
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

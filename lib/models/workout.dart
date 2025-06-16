import 'package:sqflite/sqflite.dart';
import '../db/database_helper.dart';
import '../db/table_defs.dart';
import 'exercise.dart';

class Workout {
  final int? id;
  final String name;
  final String? note;
  final List<Exercise> exercises;

  Workout({this.id, required this.name, this.note, List<Exercise>? exercises})
    : exercises = exercises ?? [];

  factory Workout.fromMap(
    Map<String, dynamic> map, {
    List<Exercise>? exercises,
  }) {
    return Workout(
      id: map['id'] as int?,
      name: map['name'] as String,
      note: map['note'] as String?,
      exercises: exercises,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'note': note,
      // Exercises stored separately
    };
  }
}

extension WorkoutDao on Workout {
  /// Inserts this Workout and returns a copy with its new [id].
  Future<Workout> insert() async {
    final db = await DatabaseHelper().database;
    final id = await db.insert(
      Tables.workout,
      toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return copyWith(id: id);
  }

  /// Fetches all Workouts.
  static Future<List<Workout>> getAll() async {
    final db = await DatabaseHelper().database;
    final maps = await db.query(Tables.workout);
    return Future.wait(
      maps.map((m) async {
        final exercises = await ExerciseDao.getByWorkout(
          m[WorkoutFields.id] as int,
        );
        return Workout.fromMap(m, exercises: exercises);
      }),
    );
  }

  /// Fetches a single Workout (with nested Exercises+Sets) by [id].
  static Future<Workout> getById(int id) async {
    final db = await DatabaseHelper().database;
    final m = (await db.query(
      Tables.workout,
      where: '${WorkoutFields.id} = ?',
      whereArgs: [id],
    )).first;
    final exercises = await ExerciseDao.getByWorkout(id);
    return Workout.fromMap(m, exercises: exercises);
  }

  /// Updates this Workout.
  Future<int> updateItem() async {
    final db = await DatabaseHelper().database;
    return db.update(
      Tables.workout,
      toMap(),
      where: '${WorkoutFields.id} = ?',
      whereArgs: [id],
    );
  }

  /// Deletes this Workout.
  Future<int> deleteItem() async {
    final db = await DatabaseHelper().database;
    return db.delete(
      Tables.workout,
      where: '${WorkoutFields.id} = ?',
      whereArgs: [id],
    );
  }

  Workout copyWith({
    int? id,
    String? name,
    String? note,
    List<Exercise>? exercises,
  }) {
    return Workout(
      id: id ?? this.id,
      name: name ?? this.name,
      note: note ?? this.note,
      exercises: exercises ?? this.exercises,
    );
  }
}

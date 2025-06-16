import 'package:sqflite/sqflite.dart';
import '../db/database_helper.dart';
import '../db/table_defs.dart';
import 'exercise_set.dart';

class Exercise {
  final int? id;
  final String name;
  final String? note;
  final List<ExerciseSet> sets;

  Exercise({this.id, required this.name, this.note, List<ExerciseSet>? sets})
    : sets = sets ?? [];

  factory Exercise.fromMap(
    Map<String, dynamic> map, {
    List<ExerciseSet>? sets,
  }) {
    return Exercise(
      id: map['id'] as int?,
      name: map['name'] as String,
      note: map['note'] as String?,
      sets: sets,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'note': note,
      // Note: you'll typically store sets in a separate table and join them.
    };
  }
}

extension ExerciseDao on Exercise {
  /// Inserts this Exercise and returns a copy with its new [id].
  Future<Exercise> insert() async {
    final db = await DatabaseHelper().database;
    final id = await db.insert(
      Tables.exercise,
      toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return copyWith(id: id);
  }

  /// Fetches all Exercises in the DB.
  static Future<List<Exercise>> getAll() async {
    final db = await DatabaseHelper().database;
    final maps = await db.query(Tables.exercise);
    return Future.wait(
      maps.map((m) async {
        final sets = await db.query(
          Tables.exerciseSet,
          where: '${ExerciseSetFields.id} = ?',
          whereArgs: [m[ExerciseFields.id]],
        );
        return Exercise.fromMap(
          m,
          sets: sets.map((s) => ExerciseSet.fromMap(s)).toList(),
        );
      }),
    );
  }

  /// Fetches all Exercises for a given [workoutId].
  static Future<List<Exercise>> getByWorkout(int workoutId) async {
    final db = await DatabaseHelper().database;
    final maps = await db.query(
      Tables.exercise,
      where: '${ExerciseFields.id} = ?',
      whereArgs: [workoutId],
    );
    return Future.wait(
      maps.map((m) async {
        final sets = await db.query(
          Tables.exerciseSet,
          where: '${ExerciseSetFields.id} = ?',
          whereArgs: [m[ExerciseFields.id]],
        );
        return Exercise.fromMap(
          m,
          sets: sets.map((s) => ExerciseSet.fromMap(s)).toList(),
        );
      }),
    );
  }

  /// Updates this Exercise.
  Future<int> updateItem() async {
    final db = await DatabaseHelper().database;
    return db.update(
      Tables.exercise,
      toMap(),
      where: '${ExerciseFields.id} = ?',
      whereArgs: [id],
    );
  }

  /// Deletes this Exercise.
  Future<int> deleteItem() async {
    final db = await DatabaseHelper().database;
    return db.delete(
      Tables.exercise,
      where: '${ExerciseFields.id} = ?',
      whereArgs: [id],
    );
  }

  Exercise copyWith({
    int? id,
    String? name,
    String? note,
    List<ExerciseSet>? sets,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      note: note ?? this.note,
      sets: sets ?? this.sets,
    );
  }
}

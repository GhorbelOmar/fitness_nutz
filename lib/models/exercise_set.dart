import 'package:sqflite/sqflite.dart';
import '../db/database_helper.dart';
import '../db/table_defs.dart';

class ExerciseSet {
  final int? id;
  final int? reps;
  final double? weight;
  final bool workingSet;
  final String? note;

  ExerciseSet({
    this.id,
    this.reps,
    this.weight,
    this.workingSet = false,
    this.note,
  });

  factory ExerciseSet.fromMap(Map<String, dynamic> map) {
    return ExerciseSet(
      id: map['id'] as int?,
      reps: map['reps'] as int,
      weight: (map['weight'] as num).toDouble(),
      workingSet: (map['working_set'] as int) == 1,
      note: map['note'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reps': reps,
      'weight': weight,
      'working_set': workingSet ? 1 : 0,
      'note': note,
    };
  }
}

extension ExerciseSetDao on ExerciseSet {
  Future<ExerciseSet> insert() async {
    final db = await DatabaseHelper().database;
    final id = await db.insert(
      Tables.exerciseSet,
      toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return copyWith(id: id);
  }

  static Future<List<ExerciseSet>> getByExercise(int exerciseId) async {
    final db = await DatabaseHelper().database;
    final maps = await db.query(
      Tables.exerciseSet,
      where: '${ExerciseSetFields.id} = ?',
      whereArgs: [exerciseId],
    );
    return maps.map((m) => ExerciseSet.fromMap(m)).toList();
  }

  Future<int> updateItem() async {
    final db = await DatabaseHelper().database;
    return db.update(
      Tables.exerciseSet,
      toMap(),
      where: '${ExerciseSetFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteItem() async {
    final db = await DatabaseHelper().database;
    return db.delete(
      Tables.exerciseSet,
      where: '${ExerciseSetFields.id} = ?',
      whereArgs: [id],
    );
  }

  ExerciseSet copyWith({
    int? id,
    int? reps,
    double? weight,
    bool? workingSet,
    String? note,
  }) {
    return ExerciseSet(
      id: id ?? this.id,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      workingSet: workingSet ?? this.workingSet,
      note: note ?? this.note,
    );
  }
}

import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'table_defs.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();
  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'workout_app.db');
    _database = await openDatabase(path, version: 1, onCreate: _onCreate);
    return _database!;
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    // ExerciseSet table
    await db.execute('''
      CREATE TABLE ${Tables.exerciseSet} (
        ${ExerciseSetFields.id}         INTEGER PRIMARY KEY AUTOINCREMENT,
        ${ExerciseSetFields.reps}       INTEGER NOT NULL,
        ${ExerciseSetFields.weight}     REAL    NOT NULL,
        ${ExerciseSetFields.workingSet} INTEGER NOT NULL,
        ${ExerciseSetFields.note}       TEXT
      )
    ''');
    // Exercise table
    await db.execute('''
      CREATE TABLE ${Tables.exercise} (
        ${ExerciseFields.id}    INTEGER PRIMARY KEY AUTOINCREMENT,
        ${ExerciseFields.name}  TEXT    NOT NULL,
        ${ExerciseFields.note}  TEXT
      )
    ''');
    // Workout table
    await db.execute('''
      CREATE TABLE ${Tables.workout} (
        ${WorkoutFields.id}    INTEGER PRIMARY KEY AUTOINCREMENT,
        ${WorkoutFields.name}  TEXT    NOT NULL,
        ${WorkoutFields.note}  TEXT
      )
    ''');
    // Program table
    await db.execute('''
      CREATE TABLE ${Tables.program} (
        ${ProgramFields.id}   INTEGER PRIMARY KEY AUTOINCREMENT,
        ${ProgramFields.name} TEXT    NOT NULL,
        ${ProgramFields.note} TEXT
      )
    ''');
    // Program‑Schedule join table
    await db.execute('''
      CREATE TABLE ${Tables.schedule} (
        ${ScheduleFields.programId} INTEGER NOT NULL,
        ${ScheduleFields.dayOfWeek} TEXT    NOT NULL,
        ${ScheduleFields.workoutId} INTEGER NOT NULL,
        PRIMARY KEY (${ScheduleFields.programId}, ${ScheduleFields.dayOfWeek}),
        FOREIGN KEY (${ScheduleFields.programId})
          REFERENCES ${Tables.program}(${ProgramFields.id})
          ON DELETE CASCADE,
        FOREIGN KEY (${ScheduleFields.workoutId})
          REFERENCES ${Tables.workout}(${WorkoutFields.id})
          ON DELETE CASCADE
      )
    ''');
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}

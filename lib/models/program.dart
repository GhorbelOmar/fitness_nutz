import 'package:sqflite/sqflite.dart';
import '../db/database_helper.dart';
import '../db/table_defs.dart';
import 'workout.dart';

enum DayOfWeekEnum {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

class Program {
  final int? id;
  final String name;
  final String? note;

  /// Maps each day-of-week to a Workout.
  final Map<DayOfWeekEnum, Workout> schedule;

  Program({
    this.id,
    required this.name,
    this.note,
    Map<DayOfWeekEnum, Workout>? schedule,
  }) : schedule = schedule ?? {};

  factory Program.fromMap(
    Map<String, dynamic> map, {
    Map<DayOfWeekEnum, Workout>? schedule,
  }) {
    return Program(
      id: map['id'] as int?,
      name: map['name'] as String,
      note: map['note'] as String?,
      schedule: schedule,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'note': note,
      // You may serialize schedule separately, e.g. as JSON or separate table
    };
  }
}

extension ProgramDao on Program {
  /// Inserts this Program and returns a copy with its new [id].
  Future<Program> insert() async {
    final db = await DatabaseHelper().database;
    final newId = await db.insert(
      Tables.program,
      toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return copyWith(id: newId);
  }

  /// Fetches all Programs (schedules nested).
  static Future<List<Program>> getAll() async {
    final db = await DatabaseHelper().database;
    final maps = await db.query(Tables.program);
    return Future.wait(
      maps.map((m) async => await getById(m[ProgramFields.id] as int)),
    );
  }

  /// Fetches a single Program (with schedule → Workouts → Exercises → Sets).
  static Future<Program> getById(int id) async {
    final db = await DatabaseHelper().database;

    // 1) load program record
    final m = (await db.query(
      Tables.program,
      where: '${ProgramFields.id} = ?',
      whereArgs: [id],
    )).first;

    // 2) load schedule entries
    final schedMaps = await db.query(
      Tables.schedule,
      where: '${ScheduleFields.programId} = ?',
      whereArgs: [id],
    );

    // 3) build schedule
    final schedule = <DayOfWeekEnum, Workout>{};
    for (final s in schedMaps) {
      final day = DayOfWeekEnum.values.firstWhere(
        (e) =>
            e.toString() ==
            'DayOfWeekEnum.${s[ScheduleFields.dayOfWeek] as String}',
      );
      final w = await WorkoutDao.getById(s[ScheduleFields.workoutId] as int);
      schedule[day] = w;
    }

    return Program.fromMap(m, schedule: schedule);
  }

  /// Updates this Program.
  Future<int> updateItem() async {
    final db = await DatabaseHelper().database;
    return db.update(
      Tables.program,
      toMap(),
      where: '${ProgramFields.id} = ?',
      whereArgs: [id],
    );
  }

  /// Deletes this Program (cascade drops schedule entries).
  Future<int> deleteItem() async {
    final db = await DatabaseHelper().database;
    return db.delete(
      Tables.program,
      where: '${ProgramFields.id} = ?',
      whereArgs: [id],
    );
  }

  /// Assigns [workout] on [day] in the program schedule.
  Future<void> assignWorkout(DayOfWeekEnum day, Workout workout) async {
    final db = await DatabaseHelper().database;
    await db.insert(Tables.schedule, {
      ScheduleFields.programId: id,
      ScheduleFields.dayOfWeek: day.toString().split('.').last,
      ScheduleFields.workoutId: workout.id,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Removes the workout assigned on [day].
  Future<int> removeWorkout(DayOfWeekEnum day) async {
    final db = await DatabaseHelper().database;
    return db.delete(
      Tables.schedule,
      where:
          '${ScheduleFields.programId} = ? AND ${ScheduleFields.dayOfWeek} = ?',
      whereArgs: [id, day.toString().split('.').last],
    );
  }

  Program copyWith({
    int? id,
    String? name,
    String? note,
    Map<DayOfWeekEnum, Workout>? schedule,
  }) {
    return Program(
      id: id ?? this.id,
      name: name ?? this.name,
      note: note ?? this.note,
      schedule: schedule ?? this.schedule,
    );
  }
}

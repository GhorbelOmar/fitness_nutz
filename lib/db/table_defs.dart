class Tables {
  static const exerciseSet = 'exercise_sets';
  static const exercise = 'exercises';
  static const workout = 'workouts';
  static const program = 'programs';
  static const schedule = 'program_schedule';
}

class ExerciseSetFields {
  static const id = 'id';
  static const reps = 'reps';
  static const weight = 'weight';
  static const workingSet = 'working_set';
  static const note = 'note';
}

class ExerciseFields {
  static const id = 'id';
  static const name = 'name';
  static const note = 'note';
}

class WorkoutFields {
  static const id = 'id';
  static const name = 'name';
  static const note = 'note';
}

class ProgramFields {
  static const id = 'id';
  static const name = 'name';
  static const note = 'note';
}

class ScheduleFields {
  static const programId = 'program_id';
  static const dayOfWeek = 'day_of_week';
  static const workoutId = 'workout_id';
}

class DayOfWeekFields {
  static const monday = 'monday';
  static const tuesday = 'tuesday';
  static const wednesday = 'wednesday';
  static const thursday = 'thursday';
  static const friday = 'friday';
  static const saturday = 'saturday';
  static const sunday = 'sunday';
}
// This file defines the table names and field names used in the database schema.
// It is used to ensure consistency across the database operations and models.
# SQLite DAO Enhancements

This document outlines how to implement each of the recommended improvements to our DAO extensions for `Exercise`, `Workout`, and `Program`.

---

## 1. Eager Loading of Nested Entities

**Goal**: Ensure that when fetching a parent record (e.g., a `Workout`), all related child records (`Exercise` → `ExerciseSet`) are loaded in one method.

**Implementation**:
1. In each `getBy…` method, wrap queries in a single method that:
   - Queries the parent table by ID or filter.
   - Queries the child table using a `WHERE parent_id = ?` clause.
   - Maps child rows to model objects.
   - Attaches the list of child objects to the parent model and returns it.
2. Use `Future.wait` or iterative loops with `await` to assemble nested lists.

---

## 2. Managing the `program_schedule` Join Table

**Goal**: Provide clear methods to assign or remove `Workout`s on specific days within a `Program`.

**Implementation**:
1. Add an `assignWorkout(day, workout)` method:
   - Use `db.insert` on the `program_schedule` table with `ConflictAlgorithm.replace`.
2. Add a `removeWorkout(day)` method:
   - Use `db.delete` filtering on both `program_id` and `day_of_week`.

---

## 3. Wrapping Multi-Step Loads in a Transaction

**Goal**: Improve performance and ensure consistency when performing multiple related queries.

**Implementation**:
1. Use `await db.transaction((txn) async { ... })` in methods that:
   - Fetch a parent record.
   - Fetch multiple child records.
   - Possibly insert or update across tables.
2. Within the transaction callback (`txn`), replace `db.query` and `db.insert` calls with `txn.query`/`txn.insert`.

---

## 4. Schema Evolution with `onUpgrade`

**Goal**: Safely migrate existing user databases when the schema changes (e.g., adding columns or tables).

**Implementation**:
1. Bump the `version` number in `openDatabase`.
2. Implement an `onUpgrade(db, oldVersion, newVersion)` callback that:
   - Uses `if (oldVersion < 2) { ... }` blocks to apply incremental `ALTER TABLE` or `CREATE TABLE` statements.
   - Ensures each migration path handles only the required changes.

---

## 5. Batch Operations for Bulk Inserts/Updates

**Goal**: Efficiently handle large numbers of insert/update operations.

**Implementation**:
1. Use `Batch batch = db.batch();` to create a batch object.
2. For each model instance:
   - Call `batch.insert(...)` or `batch.update(...)` instead of individual `db` calls.
3. Execute all operations at once with `await batch.commit(noResult: true);`.

---

*These steps will make your data layer more robust, performant, and maintainable as the app grows.*
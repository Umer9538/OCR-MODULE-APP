import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/health_record_model.dart';

/// Service for local SQLite database operations
class LocalDatabaseService {
  static Database? _database;
  static const String _tableName = 'health_records';

  /// Get database instance (singleton)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize the database
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'health_records.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT NOT NULL,
            image_path TEXT NOT NULL,
            extracted_text TEXT NOT NULL,
            created_at INTEGER NOT NULL
          )
        ''');
        await db.execute(
          'CREATE INDEX idx_email ON $_tableName (email)',
        );
      },
    );
  }

  /// Save a health record
  Future<int> saveRecord(HealthRecord record) async {
    final db = await database;
    return await db.insert(_tableName, record.toMap());
  }

  /// Get records by email
  Future<List<HealthRecord>> getRecordsByEmail(String email) async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      where: 'email = ?',
      whereArgs: [email],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => HealthRecord.fromMap(map)).toList();
  }

  /// Delete a record by id
  Future<int> deleteRecord(int id) async {
    final db = await database;
    return await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  /// Get all records
  Future<List<HealthRecord>> getAllRecords() async {
    final db = await database;
    final maps = await db.query(_tableName, orderBy: 'created_at DESC');
    return maps.map((map) => HealthRecord.fromMap(map)).toList();
  }
}

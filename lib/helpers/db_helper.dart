import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as p;

class DBHelper {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      p.join(dbPath, 'places.db'),
      version: 2, // bumped to 2
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE user_places('
          'id TEXT PRIMARY KEY, '
          'title TEXT, '
          'image TEXT, '
          'loc_lat REAL, '
          'loc_lng REAL, '
          'rating INTEGER)',
        );
      },
    );
  }

  static Future<void> insert(String table, Map<String, Object?> data) async {
    final db = await database();
    await db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await database();
    return db.query(table);
  }
}

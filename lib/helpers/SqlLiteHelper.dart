import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _db;

  DatabaseHelper._instance();

  static final String table1Name = 'Building';
  static final String table2Name = 'Floor';
  static final String table3Name = 'Section';
  static final String table4Name = 'Room';

  static const String _id = 'id';
  static const String _name = 'name';

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db!;
  }

  Future<Database> _initDb() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, 'our_map_v2.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE $table1Name($_id INTEGER PRIMARY KEY, $_name TEXT)',
        );
        await db.execute(
          'CREATE TABLE $table2Name($_id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT, buildingId INTEGER)',
        );
        await db.execute(
          'CREATE TABLE $table3Name($_id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT, buildingId INTEGER,floorId INTEGER)',
        );
        await db.execute(
          'CREATE TABLE $table4Name($_id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT , buildingId INTEGER,floorId INTEGER,sectionId INTEGER,note TEXT DEFAULT "")',
        );
      },
    );
  }
}
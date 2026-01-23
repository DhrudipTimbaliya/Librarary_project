import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static Database? database;

  Future<Database> getDatabase() async {
    if (database != null) {
      return database!;
    }
    database = await openDB();
    return database!;
  }

  Future<Database> openDB() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'book.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: createTables,
    );
  }

  Future<void> createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE books(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        Auth TEXT,
        description TEXT,
        cate TEXT,
        date TEXT,
        pdf TEXT,
        image TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE category(
        cat_id INTEGER PRIMARY KEY AUTOINCREMENT,
        cat_name TEXT,
        cat_desc TEXT
      )
    ''');
  }
}

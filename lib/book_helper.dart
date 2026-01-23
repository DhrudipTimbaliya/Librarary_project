import 'database_helper.dart';

class BookHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<int> insert(Map<String, dynamic> data) async {
    var db = await databaseHelper.getDatabase();
    return await db.insert('books', data);
  }

  Future<List<Map<String, dynamic>>> fetchAll() async {
    var db = await databaseHelper.getDatabase();
    return await db.query('books', orderBy: 'id DESC');
  }

  Future<List<Map<String, dynamic>>> fetch(int id) async {
    var db = await databaseHelper.getDatabase();
    return await db.query(
      'books',
      where: 'id=?',
      whereArgs: [id],
    );
  }

  Future<int> update(int id, Map<String, dynamic> data) async {
    var db = await databaseHelper.getDatabase();
    return await db.update(
      'books',
      data,
      where: 'id=?',
      whereArgs: [id],
    );
  }

  Future<int> delete(int id) async {
    var db = await databaseHelper.getDatabase();
    return await db.delete(
      'books',
      where: 'id=?',
      whereArgs: [id],
    );
  }
}

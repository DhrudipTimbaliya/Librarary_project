import 'database_helper.dart';

class CategoryHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<int> insert(Map<String, dynamic> data) async {
    var db = await databaseHelper.getDatabase();
    return await db.insert('category', data);
  }

  Future<List<Map<String, dynamic>>> fetchAll() async {
    var db = await databaseHelper.getDatabase();
    return await db.query('category', orderBy: 'cat_id DESC');
  }

  Future<List<Map<String, dynamic>>> fetch(int id) async {
    var db = await databaseHelper.getDatabase();
    return await db.query(
      'category',
      where: 'cat_id=?',
      whereArgs: [id],
    );
  }

  Future<int> update(int id, Map<String, dynamic> data) async {
    var db = await databaseHelper.getDatabase();
    return await db.update(
      'category',
      data,
      where: 'cat_id=?',
      whereArgs: [id],
    );
  }

  Future<int> delete(int id) async {
    var db = await databaseHelper.getDatabase();
    return await db.delete(
      'category',
      where: 'cat_id=?',
      whereArgs: [id],
    );
  }
}

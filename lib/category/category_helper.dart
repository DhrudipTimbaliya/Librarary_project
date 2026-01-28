import '../database/database_helper.dart';

class CategoryHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<int> insert(Map<String, dynamic> data) async {
    var db = await databaseHelper.getDatabase();
    return await db.insert('category', data);
  }

  Future<List<Map<String, dynamic>>> fetchAll({String? keyword}) async {
    var db = await databaseHelper.getDatabase();
    if(keyword==null || keyword!.trim().isEmpty)
      {
        return await db.query('category', orderBy: 'cat_id DESC');
      }else {
      return await db.query(
        'category',
        where: 'cat_name LIKE ? OR cat_desc LIKE ?',
        whereArgs: ['%$keyword%', '%$keyword%'],
        orderBy: 'cat_id DESC',
      );

    }
  }

  Future<List<Map<String, dynamic>>> fetch(int id) async {
    var db = await databaseHelper.getDatabase();
    return await db.query(
      'category',
      where: 'cat_id=?',
      whereArgs: [id],
    );
  }
  Future<String?> fetchCategoryName(int id) async {
    var db = await databaseHelper.getDatabase();

    final result = await db.query(
      'category',
      columns: ['cat_name'],
      where: 'cat_id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['cat_name'] as String;
    }
    return null;
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

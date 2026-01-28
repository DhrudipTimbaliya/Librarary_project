import '../database/database_helper.dart';

class AutherHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<int> insert(Map<String, dynamic> data) async {
    var db = await databaseHelper.getDatabase();
    return await db.insert('auther', data);
  }

  Future<List<Map<String, dynamic>>> fetchAll({String? keyword}) async {
    var db = await databaseHelper.getDatabase();
    if(keyword==null || keyword!.trim().isEmpty)
    {
      return await db.query('auther', orderBy: 'aut_id DESC');
    }else {
      return await db.query(
        'auther',
        where: 'aut_name LIKE ? OR aut_about LIKE ?',
        whereArgs: ['%$keyword%', '%$keyword%'],
        orderBy: 'aut_id DESC',
      );

    }
  }

  Future<List<Map<String, dynamic>>> fetch(int id) async {
    var db = await databaseHelper.getDatabase();
    return await db.query(
      'auther',
      where: 'aut_id=?',
      whereArgs: [id],
    );
  }
  Future<String?> fetchAutherName(int id) async {
    var db = await databaseHelper.getDatabase();

    final result = await db.query(
      'auther',
      columns: ['aut_name'],
      where: 'aut_id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['aut_name'] as String;
    }
    return null;
  }


  Future<int> update(int id, Map<String, dynamic> data) async {
    var db = await databaseHelper.getDatabase();
    return await db.update(
      'auther',
      data,
      where: 'aut_id=?',
      whereArgs: [id],
    );
  }

  Future<int> delete(int id) async {
    var db = await databaseHelper.getDatabase();
    return await db.delete(
      'auther',
      where: 'aut_id=?',
      whereArgs: [id],
    );
  }
}

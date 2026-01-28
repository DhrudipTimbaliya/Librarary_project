import '../database/database_helper.dart';

class BookHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<int> insert(Map<String, dynamic> data) async {
    var db = await databaseHelper.getDatabase();
    return await db.insert('books', data);
  }

  Future<List<Map<String, dynamic>>> fetchAll({String? keyword}) async {
    var db = await databaseHelper.getDatabase();
    if(keyword == null || keyword.trim().isEmpty){
      return await db.query('books', orderBy: 'id DESC');
    }
    else{

      return await db.query(
        'books',
        orderBy: 'id DESC',
        where: 'name LIKE ?  OR cate = ?',
        whereArgs: ['%$keyword%',  keyword],
      );
      // OR Auth LIKE ?
      // '%$keyword%',
    }
  }



  Future<List<Map<String, dynamic>>> fetchFilteredBooks({
    String? keyword,
    String? categoryId,
    List<String>? authorIds,
    bool matchAll = true,
  }) async {
    final db = await databaseHelper.getDatabase();

    final List<String> conditions = [];
    final List<dynamic> args = [];


    if (keyword != null && keyword.trim().isNotEmpty) {
      conditions.add('LOWER(name) LIKE ?');
      args.add('%${keyword.toLowerCase()}%');
    }


    if (categoryId != null && categoryId.isNotEmpty) {
      conditions.add('cate = ?');
      args.add(categoryId);
    }


    if (authorIds != null && authorIds.isNotEmpty) {
      final placeholders = List.filled(authorIds.length, '?').join(', ');
      conditions.add('Auth IN ($placeholders)');
      args.addAll(authorIds);
    }

    final whereClause = conditions.isNotEmpty
        ? conditions.join(matchAll ? ' AND ' : ' OR ')
        : null;

    return await db.query(
      'books',
      where: whereClause,
      whereArgs: args.isNotEmpty ? args : null,
      orderBy: 'id DESC',
    );
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

import 'auther_helper.dart';
import 'autherList.dart';
import 'package:flutter/material.dart';
import '../database/database_helper.dart';

/// ================= Auther PROVIDER =================
class AutherProvider with ChangeNotifier {
  final AutherHelper db = AutherHelper();
  List<Map<String, dynamic>> Auther = [];
  String keyword = '';


  /// GET ALL CATEGORIES
  Future<List<Map<String, dynamic>>> getAll({String? keyword}) async {
    Auther = await db.fetchAll(keyword:keyword);
    notifyListeners();
    return Auther;
  }

  /// GET ONE CATEGORY
  Future<List<Map<String, dynamic>>> getOne(int id) async {
    Auther = await db.fetch(id);
    notifyListeners();
    return Auther;
  }

  /// GET  CATEGORY Name Find
  Future<String> getCategoryNameById(int id) async {
    final name = await db.fetchAutherName(id);
    return name ?? 'name Not Found';
  }


  /// INSERT CATEGORY
  Future<int> insert(Map<String, dynamic> data) async {
    int id = await db.insert(data);
    await getAll();
    return id;
  }

  /// UPDATE CATEGORY
  Future<int> update(Map<String, dynamic> data, int id) async {
    int res = await db.update(id, data);
    await getAll();
    return res;
  }

  /// DELETE CATEGORY
  Future<void> delete(int id) async {
    await db.delete(id);
    await getAll();
  }

  /// CLEAR LOCAL CATEGORY DATA
  void clearData() {
    Auther = [];
    notifyListeners();
  }
}

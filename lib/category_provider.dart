import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'category_helper.dart';
/// ================= CATEGORY PROVIDER =================
class CategoryProvider with ChangeNotifier {
  final CategoryHelper db = CategoryHelper();
  List<Map<String, dynamic>> categories = [];

  /// GET ALL CATEGORIES
  Future<List<Map<String, dynamic>>> getAll() async {
    categories = await db.fetchAll();
    notifyListeners();
    return categories;
  }

  /// GET ONE CATEGORY
  Future<List<Map<String, dynamic>>> getOne(int id) async {
    categories = await db.fetch(id);
    notifyListeners();
    return categories;
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
    categories = [];
    notifyListeners();
  }
}

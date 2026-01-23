// import '';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// class dbHelper_category {
//   Database? db;
//
//   Future<Database?> getdb() async {
//     if(db==null){
//       return db=await openDB();
//     }
//     else{
//       return db;
//     }
//   }
//
//   Future<Database> openDB() async {
//     var directory = await getApplicationDocumentsDirectory();
//     String path = join(directory.path,"book.db");
//     var userdb = await openDatabase(
//       path,
//       version: 3,
//       onCreate: (db, version) async {
//         await db.execute('''
//         CREATE TABLE category(
//           cat_id INTEGER PRIMARY KEY AUTOINCREMENT,
//           cat_name TEXT NOT NULL,
//           cat_desc TEXT NOT NULL
//         )
//       ''');
//       },
//     );
//     return userdb;
//   }
//
//   Future<int> cat_insert(Map<String, dynamic> data) async {
//     var dbclient = await getdb();
//     int res = await dbclient!.insert("category", data);
//     return res;
//   }
//
//
//   Future<List<Map<String,dynamic>>>cat_fetchall()async{
//     var dbclient = await getdb();
//     List<Map<String,dynamic>> rec = await dbclient!.query("category",orderBy: "cat_id DESC");
//     return rec;
//   }
//
//   Future<List<Map<String,dynamic>>>cat_fetch(int cat_id)async{
//     var dbclient = await getdb();
//     List<Map<String,dynamic>> rec = await dbclient!.query("category",where: "cat_id=?",whereArgs: [cat_id]);
//     return rec;
//   }
//
//   Future<int>cat_delete(int cat_id) async{
//     var dbclient = await getdb();
//     int res = await dbclient!.delete("category",where: "cat_id=?",whereArgs: [cat_id]);
//     return res;
//
//   }
//
//   Future<int> cat_update(Map<String,dynamic> data, int cat_id ) async {
//     var dbclient = await getdb();
//     int res = await dbclient!.update("category",data,where: "cat_id=?",whereArgs:[cat_id]);
//     return res;
//   }
// }
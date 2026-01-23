//
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// class dbHelper {
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
//         CREATE TABLE books(
//           id INTEGER PRIMARY KEY AUTOINCREMENT,
//           name TEXT ,
//           Auth TEXT ,
//           desc TEXT ,
//           cate TEXT,
//           date TEXT,
//           pdf TEXT,
//           image TEXT
//         // )
//       ''');
//       },
//     );
//     return userdb;
//     }
//
//   Future<int> insert(Map<String, dynamic> data) async {
//     var dbclient = await getdb();
//     int res = await dbclient!.insert("books", data);
//     return res;
//   }
//
//
//   Future<List<Map<String,dynamic>>>fetchall()async {
//       var dbclient = await getdb();
//       List<Map<String,dynamic>> rec = await dbclient!.query("books",orderBy: "id DESC");
//       return rec;
//     }
//
//      Future<List<Map<String,dynamic>>>fetch(int id)async {
//        var dbclient = await getdb();
//        List<Map<String,dynamic>> rec = await dbclient!.query("books",where: "id=?",whereArgs: [id]);
//        return rec;
//      }
//
//     Future<int>delete(int id) async {
//       var dbclient = await getdb();
//       int res = await dbclient!.delete("books",where: "id=?",whereArgs: [id]);
//       return res;
//
//     }
//
//     Future<int> update(Map<String,dynamic> data, int id ) async {
//       var dbclient = await getdb();
//       int res = await dbclient!.update("books",data,where: "id=?",whereArgs:[id]);
//       return res;
//     }
// }
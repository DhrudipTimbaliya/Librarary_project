import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'book_helper.dart';


/// ================= BOOK PROVIDER =================
class DataSet with ChangeNotifier {
  final BookHelper record = BookHelper();
  List<Map<String, dynamic>> data = [];
  String keyword = '';

  /// GET ALL BOOKS
  Future<List<Map<String, dynamic>>> getData(String keyword) async {
    data = await record.fetchAll(keyword:keyword);
    notifyListeners();
    return data;
  }

  /// GET ONE BOOK
  Future<List<Map<String, dynamic>>> getOne(int id) async {
    data = await record.fetch(id);
    notifyListeners();
    return data;
  }

  /// INSERT BOOK
  Future<int> insert(Map<String, dynamic> newData) async {
    int id = await record.insert(newData);
    await getData(keyword);
    return id;
  }

  /// UPDATE BOOK
  Future<int> update(Map<String, dynamic> newData, int id) async {
    int res = await record.update( id,newData);
    await getData(keyword);
    return res;
  }

  /// DELETE BOOK
  Future<void> delete(int id) async {
    await record.delete(id);
    await getData(keyword);
  }




  String? categorieslistid;
  List<int> autherlistid = [];

  /// FETCH FILTERED BOOKS
  Future<void> fetchFilteredBooks({
    String? keywordParam,
    String? categoryIdsParam,
    List<String>? authorIdsParam,
  }) async {
    final String searchKeyword =
    (keywordParam ?? keyword).trim();

    final String? categories = categorieslistid;

    final List<String> authors =
        authorIdsParam ??
            autherlistid.map((e) => e.toString()).toList();

    try {
      data = await record.fetchFilteredBooks(
        keyword: searchKeyword.isEmpty ? null : searchKeyword,
        categoryId:categories!,
        authorIds: authors.isEmpty ? null : authors,
      );

      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching filtered books: $e");
    }
  }




  /// CLEAR FILTERS
  void clearFilters() {
    keyword = '';
    categorieslistid =null;
    autherlistid = [];
    data = [];
    notifyListeners();
  }


  /// CLEAR DATA
  void clearData() {
    data = [];
    notifyListeners();
  }
}

/// ================= IMAGE PROVIDER =================
class GetImageProvider with ChangeNotifier {
  final ImagePicker picker = ImagePicker();
  File? image;

  /// PICK IMAGE FROM GALLERY
  Future<void> pickImageFromGallery() async {
    final XFile? pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedImage != null) {
      image = File(pickedImage.path);
      notifyListeners();
    }
  }

  /// CLEAR IMAGE
  void clearImage() {
    image = null;
    notifyListeners();
  }
}

/// ================= PDF PROVIDER =================
class PdfProvider with ChangeNotifier {
  File? pdfFile;

  /// PICK PDF FILE
  Future<void> pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      pdfFile = File(result.files.single.path!);
      notifyListeners();
    }
  }

  /// CLEAR PDF
  void clearPdf() {
    pdfFile = null;
    notifyListeners();
  }
}

/// ================= DATE PROVIDER =================
class PickedDate with ChangeNotifier {
  DateTime? selectDate;

  /// PICK DATE
  Future<void> pickDate(BuildContext context, {DateTime? value}) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: value ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      selectDate = date;
      notifyListeners();
    }
  }

  /// CLEAR DATE
  void clearDate() {
    selectDate = null;
    notifyListeners();
  }
}

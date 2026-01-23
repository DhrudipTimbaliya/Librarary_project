import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'book_helper.dart';


/// ================= BOOK PROVIDER =================
class DataSet with ChangeNotifier {
  final BookHelper record = BookHelper();
  List<Map<String, dynamic>> data = [];

  /// GET ALL BOOKS
  Future<List<Map<String, dynamic>>> getData() async {
    data = await record.fetchAll();
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
    await getData();
    return id;
  }

  /// UPDATE BOOK
  Future<int> update(Map<String, dynamic> newData, int id) async {
    int res = await record.update( id,newData);
    await getData();
    return res;
  }

  /// DELETE BOOK
  Future<void> delete(int id) async {
    await record.delete(id);
    await getData();
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

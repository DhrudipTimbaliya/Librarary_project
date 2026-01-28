import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:intl/intl.dart';
import '../auther/auth_provider.dart';
import '../category/category_provider.dart';
import 'provider.dart';
import 'showbook.dart';


class addbook extends StatefulWidget {
  final int? oldid;
  addbook({super.key, this.oldid});


  @override
  State<addbook> createState() => _addbookState();
  }

class _addbookState extends State<addbook> {
  List<Color> colors = [
    Color(0xFFD6A6F8),
    Color(0xFFC48AEA),
    Color(0xFFB36DDD),
    Color(0xFF9A52D1),
    Color(0xFF8838C3),
    Color(0xFF6E31A1),
    Color(0xFF55297F),
    Color(0xFFE9CAFD),
  ];
  final ImagePicker picker = ImagePicker();
  late TextEditingController name;
  late TextEditingController desc;
  late TextEditingController date;
  late TextEditingController Cate;
  DateTime? dateValue;
  File? oldpdf;
  String? oldimage;
  String? olddate;
  String? selectedCategory;
  String? selectedAuther;
  int? auth_id;
  String? authname;
  String? categoryname;
  int? category_id;

  bool showNameError = false;
  bool showDescError = false;
  bool showAuthError = false;
  bool showDateError = false;
  bool showImageError = false;
  bool showCategoryError = false;
  bool showPdfError = false;

  @override
  void initState() {
    super.initState();
    name = TextEditingController();
    desc = TextEditingController();
    date = TextEditingController();
    Cate  = TextEditingController();
    fetchcategory();
    fetchAuthermaltiple();

    if (widget.oldid != null) {
      fetchBook(widget.oldid!);
    }
  }

  @override
  void dispose() {
    name.dispose();
    desc.dispose();
    date.dispose();
    dateValue = null;
    super.dispose();
  }

  //multiple category fetch
  List<Map<String,dynamic>> catedata=[];
  Future<void> fetchcategory() async {
    try {
      final provider = Provider.of<CategoryProvider>(context, listen: false);
      List<Map<String, dynamic>> fetchedData = await provider.getAll();
      setState(() {
        catedata = fetchedData;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }


  // fetch one book full data
  Future<void> fetchBook(int id) async {
    final provider = Provider.of<DataSet>(context, listen: false);
    final data = await provider.getOne(id);

    if (data.isEmpty || !mounted) return;

    final int? catId = int.tryParse(data[0]['cate'].toString());
    String? catName;
    if (catId != null) {
      final categoryProvider =
      Provider.of<CategoryProvider>(context, listen: false);
      final categoryData = await categoryProvider.getOne(catId);
      if (categoryData.isNotEmpty) {
        catName = categoryData[0]['cat_name'];
      }
    }

    final int? auth_Id = int.tryParse(data[0]['Auth'].toString());
    String? authername;

    if (auth_Id != null) {
      final autherProvider =
      Provider.of<AutherProvider>(context, listen: false);
      final autherData = await autherProvider.getOne(auth_Id);
      if (autherData.isNotEmpty) {
        authername = autherData[0]['aut_name'];
      }
    }


    setState(() {
      name.text = data[0]['name'];
      desc.text = data[0]['description'];

      auth_id = auth_Id;
      authname = authername;
      selectedAuther = auth_Id?.toString();

      category_id = catId;
      categoryname = catName;
      selectedCategory = catId?.toString();

      oldpdf = File(data[0]['pdf']);
      oldimage = data[0]['image'];
      olddate = data[0]['date'];
    });

  }


  //auther data fetch multiple
  List<Map<String,dynamic>> autherdata=[];
  Future<void> fetchAuthermaltiple() async {
    try {
      final provider_auth = Provider.of<AutherProvider>(context, listen: false);
      List<Map<String, dynamic>> fetchedData_auth = await provider_auth.getAll();
      setState(() {
        autherdata = fetchedData_auth;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    GetImageProvider getImage = Provider.of<GetImageProvider>(context);
    PickedDate getdate = Provider.of<PickedDate>(context);
    PdfProvider getpdf = Provider.of<PdfProvider>(context);

    if (getdate.selectDate != null) {
      dateValue = getdate.selectDate!;
      date.text =
      "${getdate.selectDate!.day}-${getdate.selectDate!.month}-${getdate.selectDate!.year}";
    } else if (widget.oldid != null && olddate != null) {
      dateValue = DateFormat("dd/MM/yyyy").parse(olddate!);
      date.text = olddate!;
    } else {
      dateValue = null;
      date.text = "select publish date";
    }
    return WillPopScope(
      onWillPop: () async {
        getImage.clearImage();
        getpdf.clearPdf();
        getdate.clearDate();
        dateValue = null;
        name.clear();
        desc.clear();
        selectedAuther=null;
        selectedCategory = null;
        date.clear();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.oldid != null ? "Edit Book" : "Add Book"),
          backgroundColor: colors[0],
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [

              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: (){
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                        children: <Widget>[
                        Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          color:colors[7],
                          borderRadius: BorderRadius.circular(12),
                          border:showImageError?Border.all(color: Colors.red):Border.all(color:colors[6]),
                        ),
                        child: Center(
                          child: widget.oldid == null
                              ? getImage.image == null
                              ? Text("Add a book image")
                              : Image.file(getImage.image!, fit: BoxFit.cover)
                              : getImage.image != null
                              ? Image.file(getImage.image!, fit: BoxFit.cover)
                              : oldimage != null
                              ? Image.file(File(oldimage!), fit: BoxFit.cover)
                              : Text("No image found"),
                        ),
                      ),
                          Container(
                            height:50,
                            width: 50,
                            decoration: BoxDecoration(
                              color:Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border:Border.all(color:Colors.transparent),
                            ),
                            child: IconButton(onPressed:()async {

                                  await getImage.pickImageFromGallery();

                            }, icon:getImage.image!=null || oldimage!=null?
                            Icon(Icons.edit,color: colors[6],size: 30,):
                            Icon(Icons.camera_alt_rounded,color: colors[6],size: 30,)),
                          )
                      ]
                    ),

                  ),
                ),
              ),
              if (showImageError)
                Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: Text(
                    "Select a book image",
                    style: TextStyle(color: Colors.red),
                  ),
                ),

              SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: ElevatedButton(
                      onPressed: () async {
                        await getpdf.pickPdf();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors[2],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: showPdfError?BorderSide(color: Colors.red, width: 2):BorderSide(color: Colors.white, width: 2),
                        ),
                      ),
                      child: Text(
                        widget.oldid == null
                            ? (getpdf.pdfFile == null
                            ? "Add a PDF"
                            : p.basename(getpdf.pdfFile!.path))
                            : (getpdf.pdfFile != null
                            ? p.basename(getpdf.pdfFile!.path)
                            : p.basename(oldpdf?.path ?? "Select The Pdf")),
                        style: TextStyle(fontSize: 20, color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  (getpdf.pdfFile != null || oldpdf != null)
                      ? Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShowBook(
                                    pdf: oldpdf != null
                                        ? File(oldpdf!.path)
                                        : File(getpdf.pdfFile!.path)),
                              ),
                            );
                          },
                          child: Icon(Icons.remove_red_eye_rounded,color: Colors.white,)
                          ,style: ElevatedButton.styleFrom(
                          backgroundColor: colors[3],

                        ),
                        ),
                        SizedBox(width: 5),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (oldpdf != null) {
                                oldpdf = null;
                              } else {
                                getpdf.clearPdf();
                              }
                            });
                          },
                          child: Icon(Icons.cancel_sharp,color: Colors.white,),
                          style: ElevatedButton.styleFrom(
                          backgroundColor: colors[3],
                        ),
                        ),
                      ],
                    ),
                  )
               : Expanded(flex: 0, child: Container()),
                ],
              ),
              if (showPdfError)
                Padding(
                  padding: const EdgeInsets.only(top:5,left: 7),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Select a PDF",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),

              SizedBox(height: 16),


              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child:TextFormField(
                  controller: name,
                  decoration: InputDecoration(
                    hintText: "Enter Book Name",

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: showNameError ? Colors.redAccent : colors[6],
                        width: 2,
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: showNameError ? Colors.redAccent : colors[6],
                        width: 2,
                      ),
                    ),

                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.redAccent, width: 2),
                    ),

                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.redAccent, width: 2),
                    ),
                  ),
                ),

              ),
              if (showNameError)
                Padding(
                  padding: const EdgeInsets.only(top:5,left: 7),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Enter the Book Name",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),


              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: desc,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Description",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: showDescError ? Colors.redAccent : colors[6],
                        width: 2,
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: showDescError ? Colors.redAccent : colors[6],
                        width: 2,
                      ),
                    ),

                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.redAccent, width: 2),
                    ),

                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.redAccent, width: 2),
                    ),
                  ),
                ),
              ),
              if (showDescError)
                Padding(
                  padding: const EdgeInsets.only(top:5,left: 7),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Enter Description",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),


              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: DropdownButtonFormField<String>(
                  value: selectedAuther,
                  decoration: InputDecoration(
                    hintText: "Select the Book Auther",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: showAuthError ? Colors.redAccent : colors[6],
                        width: 2,
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: showAuthError ? Colors.redAccent : colors[6],
                        width: 2,
                      ),
                    ),

                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.redAccent, width: 2),
                    ),

                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.redAccent, width: 2),
                    ),
                  ),
                  items: autherdata.map((Auther) {
                    return DropdownMenuItem<String>(
                      value:Auther["aut_id"].toString(),
                      child: Text(Auther["aut_name"]),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedAuther = value!;
                    });
                  },
                ),
              ),


              if (showAuthError)
                Padding(
                  padding: const EdgeInsets.only(top:5,left: 7),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Enter Author Name",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),

              SizedBox(height: 10),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                    hintText: "Select the Book Category",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: showCategoryError ? Colors.redAccent : colors[6],
                        width: 2,
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: showCategoryError ? Colors.redAccent : colors[6],
                        width: 2,
                      ),
                    ),

                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.redAccent, width: 2),
                    ),

                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.redAccent, width: 2),
                    ),
                  ),
                  items: catedata.map((category) {
                    return DropdownMenuItem<String>(
                      value:category["cat_id"].toString(),
                      child: Text(category["cat_name"]),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                ),
              ),

              if (showCategoryError)
                Padding(
                  padding: const EdgeInsets.only(top:5,left: 7),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "select the category",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              SizedBox(
                height: 10,
              ),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  onTap: () {
                    if (dateValue == null) {
                      getdate.pickDate(context);
                    } else {
                      getdate.pickDate(context, value: dateValue!);
                    }
                  },
                  controller: date,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "Publish Date",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: showDateError ? Colors.redAccent : colors[6],
                        width: 2,
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: showDateError ? Colors.redAccent : colors[6],
                        width: 2,
                      ),
                    ),

                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.redAccent, width: 2),
                    ),

                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.redAccent, width: 2),
                    ),
                  ),
                ),
              ),
              if (showDateError)
                Padding(
                  padding: const EdgeInsets.only(top:5,left: 7),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Select Publish Date",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),

              SizedBox(height: 10),


              Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {

                        showNameError = name.text.isEmpty;
                        showDescError = desc.text.isEmpty;
                        showAuthError = selectedAuther == null;
                        showCategoryError = selectedCategory == null;
                        showDateError = dateValue == null;
                        showImageError = getImage.image == null && oldimage == null;
                        showPdfError = getpdf.pdfFile == null && oldpdf == null;
                      });

                      if (showNameError ||
                          showDescError ||
                          showAuthError ||
                          showCategoryError ||
                          showDateError ||
                          showImageError ||
                          showPdfError) {
                        return;
                      }

                      Map<String, dynamic> data = {
                        "name": name.text,
                        "description": desc.text,
                        "Auth": selectedAuther,
                        "cate": selectedCategory,
                        "pdf": getpdf.pdfFile?.path ?? oldpdf?.path,
                        "image": getImage.image?.path ?? oldimage,
                        "date": getdate.selectDate != null
                            ? "${getdate.selectDate!.day}/${getdate.selectDate!.month}/${getdate.selectDate!.year}"
                            : olddate,
                      };

                      final dataSetProvider =
                      Provider.of<DataSet>(context, listen: false);

                      if (widget.oldid == null) {
                        dataSetProvider.insert(data);
                        getImage.clearImage();
                        getpdf.clearPdf();
                        getdate.clearDate();
                        dateValue = null;
                        selectedCategory = null;
                        name.clear();
                        desc.clear();
                        selectedAuther=null;
                        date.clear();
                        Navigator.pop(context, true);
                      } else {
                        dataSetProvider.update(data, widget.oldid!);
                        getImage.clearImage();
                        getpdf.clearPdf();
                        getdate.clearDate();
                        dateValue = null;
                        selectedCategory = null;
                        name.clear();
                        desc.clear();
                        selectedAuther=null;
                        date.clear();
                        Navigator.pop(context);
                      }

                    },
                    child: Text(
                      widget.oldid == null ? "Add Book" : "Update Book",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors[5],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import '../auther/auth_provider.dart';
import 'addbook.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../category/category_provider.dart';
import 'provider.dart';
import 'showbook.dart';

class detilespage extends StatefulWidget {
  final int id;
  detilespage({Key? key, required this.id}) : super(key: key);
  @override
  State<detilespage> createState() => _detilespageState();
}

class _detilespageState extends State<detilespage> {
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
  
  String? name;
  String? desc;
  int? auth;
  String? date;
  String? categoryname;
  String? authname;
  int? category_id;
  File? pdf;
  String? imagePath;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBook();
  }

  Future<void> fetchBook() async {
    final detailsProvider = Provider.of<DataSet>(context, listen: false);
    final data = await detailsProvider.getOne(widget.id);

    setState(() {
      name = data[0]['name'];
      desc = data[0]['description'];
      auth = int.parse(data[0]['Auth'].toString());
      category_id = int.parse(data[0]['cate'].toString());
      pdf = File(data[0]['pdf']);
      imagePath = data[0]['image'];
      date = data[0]['date'];
      isLoading = false;
    });

    if(category_id!=null){
      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
      final categoryData = await categoryProvider.getOne(category_id!);
      setState(() {
        categoryname = categoryData[0]['cat_name'];
      });

    }
     if(auth!=null){
      final provider = Provider.of<AutherProvider>(context, listen: false);
      final fetchedData = await provider.getOne(auth!);
      setState(() {
        authname=fetchedData[0]['aut_name'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    fetchBook();
    return Scaffold(
      appBar: AppBar(
        title:  Text("Book Details"),
        centerTitle: true,
        backgroundColor: colors[0],
        actions: [
          IconButton(onPressed: ()async{

            var result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=>addbook(oldid:widget.id!)));
            },
           icon:Icon(Icons.edit_note_rounded,size: 30,),color: Colors.black),
          IconButton(onPressed: (){
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Are you sure you want to delete this book?",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.black54),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor:colors[7],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: Colors.black,width: 2),
                              ),
                            ),
                            child:Icon(Icons.cancel_sharp),
                          ),

                          OutlinedButton(
                            onPressed: () {
                              Provider.of<DataSet>(context, listen: false)
                                  .delete(widget.id);

                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor:colors[7],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: Colors.black, width: 2),
                              ),
                            ),
                            child: Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }, icon:Icon(Icons.delete),color: Colors.black),
        ],
      ),
      body: isLoading
          ?  Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding:  EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Container(
                decoration: BoxDecoration(
                  color:colors[7],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color:colors[6]),
                ),
                child: Center(
                  child: imagePath != null?Image.file(
                    File(imagePath!),
                    height: 200,
                    fit: BoxFit.cover,
                  ): Icon(Icons.book_rounded, size: 200),
                ),
              ),

             SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration:  BoxDecoration(
                    shape: BoxShape.circle,
                    color:colors[4],
                  ),
                  child: Icon(Icons.drive_file_rename_outline_rounded, color: Colors.white, size: 30),
                ),
                 SizedBox(width: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: Text(
                      name!=null?name!:"Not a Name Found",
                      style:  TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
             SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration:  BoxDecoration(
                    shape: BoxShape.circle,
                    color:colors[4],
                  ),
                  child: Icon( Icons.person, color: Colors.white, size: 30),
                ),
                 SizedBox(width: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: Text(
                      authname!=null?authname!:"Not a Auth Found",
                      style:  TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
           

             SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration:  BoxDecoration(
                    shape: BoxShape.circle,
                    color:colors[4],
                  ),
                  child: Icon(Icons.description, color: Colors.white, size: 30),
                ),
                 SizedBox(width: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: Text(
                      desc!=null?desc!!:"Not a description  Found",
                      style:  TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
           

            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration:  BoxDecoration(
                    shape: BoxShape.circle,
                    color:colors[4],
                  ),
                  child: Icon(Icons.category_rounded, color: Colors.white, size: 30),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: Text(
                      categoryname!=null?categoryname!!:"Not a category  Found",
                      style:  TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),


            SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration:  BoxDecoration(
                      shape: BoxShape.circle,
                      color:colors[4],
                    ),
                    child: Icon( Icons.access_time_sharp, color: Colors.white, size: 30),
                  ),
                   SizedBox(width: 8),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Text(
                        date!,
                        style:  TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(onPressed: (){
                  Navigator.push(
                      context,
                        MaterialPageRoute(builder: (context)=>ShowBook(pdf:File(pdf!.path))));
                }, child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.file_open_rounded),
                    SizedBox(width: 10,),
                    Text("Open a Book Pdf"),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(double.infinity, 50),
                  backgroundColor: colors[7],
                  foregroundColor: Colors.black54,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color:colors[6], width: 2),
                  ),
                )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  
}

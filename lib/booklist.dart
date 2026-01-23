import 'package:flutter/material.dart';
import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'addbook.dart';
import 'provider.dart';
import 'extra/db_helper.dart';
import 'showbook.dart';
import 'detiles.dart';

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

class BookList extends StatefulWidget {
  @override
  State<BookList> createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  List<Map<String,dynamic>> data123=[];

  Future<void> fetchBooks() async {
    try {
      final provider = Provider.of<DataSet>(context, listen: false);
      List<Map<String, dynamic>> fetchedData = await provider.getData();
      setState(() {
        data123 = fetchedData;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }


  @override
  Widget build(BuildContext context){
    fetchBooks();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,

        backgroundColor:colors[0],
        title: Text("Book Mangement",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body:SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount:data123.length,
              itemBuilder: (context, index) {
                return Container(
                  child: InkWell(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=>detilespage(id:data123[index]["id"])));

                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child:
                        Column(
                          children: [
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      height: 80,
                                      width: 80,
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: colors[6], width: 3),
                                        borderRadius: BorderRadius.circular(13),
                                        color: Colors.grey,
                                      ),
                                      child: data123[index]["image"] == null
                                          ? const Icon(Icons.book_rounded, size: 60)
                                          : Image.file(
                                        File(data123[index]["image"]),
                                        fit: BoxFit.cover,
                                      ),
                                    ),

                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Container(
                                    width: 220,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              height:20,
                                              width:20,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: colors[2],

                                                border:Border.all(color: Colors.black,width: 1),
                                              ),
                                              child: Icon(Icons.my_library_books,color: Colors.white,size: 14,),
                                            ),
                                            SizedBox(width: 5,),
                                            Text("${data123[index]["name"]}",style: TextStyle(fontWeight: FontWeight.bold),),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border:Border.all(color: Colors.black,width: 1),
                                                color:colors[2],
                                              ),
                                              child: Icon(Icons.person,color: Colors.white,size: 18,),
                                            ),
                                            SizedBox(width: 5,),
                                            Text("${data123[index]["Auth"]}",style: TextStyle(fontWeight: FontWeight.bold),),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border:Border.all(color: Colors.black,width: 1),
                                                color: colors[2],
                                              ),
                                              child: Icon(Icons.access_time_sharp,color: Colors.white,size: 18,),
                                            ),
                                            SizedBox(width: 5,),
                                            Text("${data123[index]["date"]}",
                                              style: TextStyle(fontWeight: FontWeight.bold),),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [

                                    Column(
                                      children: [
                                        Container(
                                          height: 30,
                                          width: 60,
                                          child: ElevatedButton(onPressed: ()async{
                                            int id=data123[index]["id"];
                                            var result = await Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context)=>addbook(oldid:id)));
                                            if(result!=null){
                                              fetchBooks();
                                            }
                                          },
                                            child:Icon(Icons.edit,color: Colors.white,size: 20,),
                                            style:ElevatedButton.styleFrom(
                                              backgroundColor: colors[3],
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                                side: BorderSide(color: Colors.white,width: 2),
                                              ),
                                            ),),
                                        ),

                                        SizedBox(height: 10,),
                                        Container(
                                          height: 30,
                                          width: 60,
                                          child: ElevatedButton(onPressed: (){
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
                                                                  .delete(data123[index]["id"]);
                                                              fetchBooks();
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
                                          },
                                            child:Icon(Icons.delete,color: Colors.white,size: 20,),
                                            style:ElevatedButton.styleFrom(
                                              backgroundColor:Colors.red[400],
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                                side: BorderSide(color: Colors.white,width: 2),
                                              ),
                                            ),),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),

                          ],
                        )),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      floatingActionButton:Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor:colors[5],
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=>addbook()));
            },
            tooltip: 'add a book',
            child:  Icon(Icons.add,color: Colors.white,),
          ),
        ],
      ),
    );
  }
}

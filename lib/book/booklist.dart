import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:core';
import 'dart:io';
import 'package:provider/provider.dart';
import '../auther/auth_provider.dart';
import 'addbook.dart';
import '../category/category_provider.dart';
import 'provider.dart';
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
  int?cateid;
  BookList({this.cateid});
  @override
  State<BookList> createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  List<Map<String, dynamic>> data123 = [];
  Map<int, String> categoryMap = {};
  Map<int, String> autherMap = {};
  var value2;
  bool serchdata=false;
  Timer? _debounce;
  TextEditingController searchController = TextEditingController();
  int? selectedCategoryId;
  int? selectedAutherId;
  late String selectedCategoryIds =widget.cateid!.toString();
  List<Map<String,dynamic>> categorieslist = [];
  List<Map<String,dynamic>> autherslist = [];


  List<int> selectedAuthorIds = [];

  bool showCategoryList = false;
  bool showAuthorList = false;

  void _searchNow(String value) {
    final keyword = value.trim();


    if (keyword.isEmpty) {
      fetchBooks();
      return;
    }

    int? catId;
    categoryMap.forEach((id, name) {
      if (name.toLowerCase().contains(keyword.toLowerCase())) {
        catId = id;
      }
    });

    int? AuthId;
    autherMap.forEach((id, name) {
      if (name.toLowerCase().contains(keyword.toLowerCase())) {
        AuthId = id;
      }
    });

    fetchBooks(
      query: catId?.toString() ??
          AuthId?.toString() ??
          keyword,
    );

  }



  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchNow(value);
    });
  }

  void _onSearchSubmitted(String value) {
    _debounce?.cancel();
    Navigator.pop(context);
    _searchNow(value);
  }

  Future<void> filterclear()async{
    final provider = Provider.of<DataSet>(context, listen: false);

    provider.clearFilters();
    await provider.fetchFilteredBooks();
    await loadFromProvider(); // 🔥

    setState(() {
      selectedAuthorIds.clear();
      showCategoryList = false;
      showAuthorList = false;
      searchController.clear();
      fetchBooks();
    });

  }

  void showSearchDropdown(BuildContext context) {
    final TextEditingController serch = TextEditingController();
    int x=0;
    final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;

    showMenu(
      context: context,
      constraints: BoxConstraints(
      maxWidth:double.infinity,
      ),
      position: RelativeRect.fromLTRB(
        50, 50,
        0,  0,
      ),
      items: [
        PopupMenuItem(

          enabled: false,
          child: Container(

            width:400,
            child:TextField(
              controller: searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
              onChanged: _onSearchChanged,      // ⏱ debounce
              onSubmitted: _onSearchSubmitted, // ⚡ instant
            ),

          ),
        ),
      ],
    );
  }

  Future<void> fetchBooks({String? query}) async {
    query ??= widget.cateid?.toString();

    print(query);

  try {
      final provider = Provider.of<DataSet>(context, listen: false);
      List<Map<String, dynamic>> fetchedData = await provider.getData(query!);
      setState(() {
        data123 = fetchedData;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> fetchcategory() async {
    try {
      final provider = Provider.of<CategoryProvider>(context, listen: false);
      final fetchedData = await provider.getAll();

      setState(() {
        categoryMap = {
          for (var item in fetchedData)
            item['cat_id']: item['cat_name']
        };
      });
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  List<Map<String,dynamic>> autherdata=[];
  Future<void> fetchAuther() async {
    try {
      final provider_auth = Provider.of<AutherProvider>(context, listen: false);
      final fetchedData_auth = await provider_auth.getAll();
      setState(() {
        autherMap = {
          for (var item in fetchedData_auth)
            item['aut_id']: item['aut_name']
        };
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> loadFromProvider() async {
    final provider = Provider.of<DataSet>(context, listen: false);

    setState(() {
      data123 = List<Map<String, dynamic>>.from(provider.data);
    });
  }


  @override
  void initState() {
    super.initState();
    fetchBooks();
    fetchcategory();
    fetchAuther();
    selectedCategoryIds =widget.cateid!.toString();
  }
  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  Future<void> reloadData() async {

    selectedAuthorIds.clear();
    showCategoryList = false;
    showAuthorList = false;
    searchController.clear();
    setState(() {

    });
    await fetchBooks();
    await fetchcategory();
    await fetchAuther();
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor:colors[0],
        title: Text("Book Mangement",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
        centerTitle: true,

      ),
      endDrawer: Drawer(
        backgroundColor: Color(0xFFc3abd8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Center(
                    child: Text(
                      "Filter",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                /// ================= SEARCH =================
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Search book / author / category",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black, width: 2)
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black, width: 2)
                    ),
                    focusedBorder:  OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color:colors[6], width: 2)
                    ),
                  ),
                  onChanged: _onSearchChanged,
                  // onSubmitted: _onSearchSubmitted,
                ),

                SizedBox(height: 20),

                /// ================= AUTHOR =================
                Text("Author", style: TextStyle(fontWeight: FontWeight.bold)),

                GestureDetector(
                  onTap: () {
                    setState(() => showAuthorList = !showAuthorList);
                  },
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: selectedAuthorIds.isEmpty
                              ? Text("Select Author")
                              : Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: selectedAuthorIds.map((id) {
                              return Chip(
                                label: Text(autherMap[id]!),
                                deleteIcon: Icon(Icons.close, size: 16),
                                onDeleted: () {
                                  setState(() {
                                    selectedAuthorIds.remove(id);
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                        Icon(
                          showAuthorList
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                        ),
                      ],
                    ),
                  ),
                ),

                if (showAuthorList)
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color:  colors[6]),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: autherMap.entries.map((e) {
                        return CheckboxListTile(
                          title: Text(e.value),
                          value: selectedAuthorIds.contains(e.key),
                          onChanged: (val) {
                            setState(() {
                              if (val == true &&
                                  !selectedAuthorIds.contains(e.key)) {
                                selectedAuthorIds.add(e.key);
                              } else {
                                selectedAuthorIds.remove(e.key);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),

                SizedBox(height: 30),

                /// ================= BUTTONS =================
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {

                           filterclear();
                            Navigator.pop(context);


                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(color: Colors.white, width: 2),
                          ),
                        ),
                        child: Text("Clear",style: TextStyle(color: Colors.white),),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors[7],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(color:colors[6], width: 2),
                          ),
                        ),
                        onPressed: () async {

                            final provider = Provider.of<DataSet>(context, listen: false);

                            provider.keyword = searchController.text.trim();
                            provider.categorieslistid =selectedCategoryIds;
                            provider.autherlistid = List<int>.from(selectedAuthorIds);
                            await provider.fetchFilteredBooks();
                            await loadFromProvider();
                            Navigator.pop(context);
                        },
                        child: Text("Apply"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),


      body:data123.isEmpty ? Center(child: Text("NO Record Found ",style: TextStyle(fontSize: 25),)):
        SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount:data123.length,
              itemBuilder: (context, index) {

                final int? catId =
                int.tryParse(data123[index]["cate"]?.toString() ?? '');

                final int? authId =
                int.tryParse(data123[index]["Auth"]?.toString() ?? '');

                return Container(
                  child: InkWell(
                    onTap: ()async{
                      await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=>detilespage(id:data123[index]["id"])));
                      await fetchBooks();
                      setState(() { });
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
                                            Text(autherMap[authId] ?? "Not found",style: TextStyle(fontWeight: FontWeight.bold),),
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
                                              child: Icon(Icons.category_rounded,color: Colors.white,size: 13,),
                                            ),
                                            SizedBox(width: 5,),
                                            Text(categoryMap[catId] ?? "Not found",
                                              style: TextStyle(fontWeight: FontWeight.bold),)
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
                                            filterclear();
                                            reloadData();
                                            setState(() {
                                            });
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
                                                              final provider = Provider.of<DataSet>(context, listen: false);
                                                              provider.clearFilters();

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
            onPressed: () async {
              filterclear();
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => addbook()),
              );



              if (result == true) {
                await reloadData();
              }
            },

            tooltip: 'add a book',
            child:  Icon(Icons.add,color: Colors.white,),
          ),
        ],
      ),
    );
  }
}



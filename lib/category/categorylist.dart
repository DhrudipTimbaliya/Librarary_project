import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled10/category/category_provider.dart';
import 'package:untitled10/book/provider.dart';
import 'addCategory.dart';
import 'dart:async';
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
class categoriesList extends StatefulWidget{
  @override
  State<categoriesList> createState() => _categoriesListState();
}

class _categoriesListState extends State<categoriesList> {
  List<Map<String,dynamic>> catedata=[];
   bool serchdata=false;

  TextEditingController searchController = TextEditingController();


  void showSearchDropdown(BuildContext context) {



    int x=0;
    final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;
    Timer? _debounce;


    void _searchNow(String value) {

        setState(() {
          serchdata=true;
          fetchcategory(keyword: value.toString());

        });

    }

    void _onchanged(String value) {

      if (_debounce?.isActive ?? false) _debounce!.cancel();

      _debounce = Timer(const Duration(milliseconds: 500), () {
        _searchNow(value);
      });
    }

    void _onSearchSubmitted(String value) {
      _debounce?.cancel();
      _searchNow(value);
    }

    showMenu(
      context: context,
      constraints: BoxConstraints(
        maxWidth:double.infinity,
      ),
      position: RelativeRect.fromLTRB(
        50, 50, // top (below AppBar)
        0,  0, // bottom
      ),
      items: [
        PopupMenuItem(

          enabled: false,
          child: Container(

            width:400,
            child: TextField(
              controller:searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
              onChanged:_onchanged,
              onSubmitted:_onSearchSubmitted,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> fetchcategory({String? keyword}) async {
    try {
      final provider = Provider.of<CategoryProvider>(context, listen: false);
      List<Map<String, dynamic>> fetchedData = await provider.getAll(keyword: keyword);
      setState(() {
        catedata = fetchedData;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchcategory();
  }
  Future<void> reloadData() async {
    await fetchcategory();
  }

  void deletebook(int catId) async {
    final provider = Provider.of<DataSet>(context, listen: false);
    List<Map<String, dynamic>> booksToDelete = provider.data
        .where((book) => book['cate'].toString() == catId.toString())
        .toList();

    for (var book in booksToDelete) {
      await provider.delete(book['id']);
    }


  }



  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors[0],
        automaticallyImplyLeading: false,
        title: Text("Categories List"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearchDropdown(context);
            },
          ),
        ],
      ),
      body:catedata.isEmpty?Center(child: Text("Category Not Found",style: TextStyle(fontSize: 25),))
          :ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount:catedata.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(

                  child: Card(
                    child: Row(

                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              color:colors[7],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color:colors[6]),
                            ),
                            child: Icon(Icons.category_rounded,size: 50,),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25),
                          child: Container(
                            width: 180,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color:colors[2],
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            color:colors[6]),
                                      ),
                                        child: Icon(Icons.category_outlined)),
                                    SizedBox(width: 10,),
                                    Expanded(child: Text("${catedata[index]["cat_name"]}",softWrap: true,)),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          color:colors[2],
                                          borderRadius: BorderRadius.circular(15),
                                          border: Border.all(
                                              color:colors[6]),
                                        ),
                                        child: Icon(Icons.description)),
                                    SizedBox(width: 10,),
                                    Expanded(child: Text("${catedata[index]["cat_desc"]}",softWrap: true,)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ElevatedButton(onPressed: ()async{
                                serchdata=false;
                                    var result= await Navigator.push(context,
                                        MaterialPageRoute(builder: (context)=>addCategory(cat_id:catedata[index]["cat_id"])) );

                                        fetchcategory();

                                    setState(() {

                                    });

                              }, child: Icon(Icons.mode_edit_outline_rounded,color: Colors.white,)
                              ,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colors[5],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(color: Colors.white, width: 2),
                                ),
                              )
                              ),
                              ElevatedButton(onPressed: (){
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Are you sure you want to delete this category?",
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
                                                  Provider.of<CategoryProvider>(context, listen: false)
                                                      .delete(catedata[index]["cat_id"]);
                                                  fetchcategory();
                                                  deletebook(catedata[index]["cat_id"]);
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

                              }, child: Icon(Icons.delete_rounded,color: Colors.white,),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: colors[5],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(color: Colors.white, width: 2),
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),
                        ]
                    ),
                  ),
              ),
            );
          }
      ),

      floatingActionButton:FloatingActionButton(
          backgroundColor:colors[5],
          onPressed: ()async{
            serchdata=false;
            var result= await Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=>addCategory()));

              fetchcategory();

            setState(() {

            });
          },
        child: Icon(Icons.add,color: Colors.white,),
      )
    );
  }
}
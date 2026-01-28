import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'addauther.dart';
import 'auth_provider.dart';




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

class autherList extends StatefulWidget{

  @override
  State<autherList> createState() => _autherListState();
}

class _autherListState extends State<autherList> {
  List<Map<String, dynamic>> info=[];

  void showSearchDropdown(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    bool serchdata=false;
    int x=0;
    final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;
    Timer? _debounce;


    void _searchNow(String value) {

      setState(() {
        serchdata=true;
        fetchAuther(keyword: value.toString());
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


  Future<void> fetchAuther({String? keyword})async{
    final provider = Provider.of<AutherProvider>(context, listen: false);
    final fetchedData = await provider.getAll(keyword: keyword);
    setState(() {
      info=fetchedData;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAuther();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
         title: Text("Auther List",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: colors[0],
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearchDropdown(context);
            },
          ),
        ],
      ),
      body:info.isEmpty? Center(
        child: Text("No Record Found",style: TextStyle(fontSize: 25),),
      ):ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: info.length,
        itemBuilder: (context,index){
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 100,
                width: double.infinity,
                child: Row(
                  children: [
                    Container(
                      height: 80,
                      width:80,
                      decoration:BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: colors[7],
                        border: Border.all(color: colors[6],width: 2),
                      ),
                      child: Icon(Icons.person_rounded,size: 60,color: Colors.black),

                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Container(
                        width: 220,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                               crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                 Container(
                                   height: 30,
                                   width: 30,
                                   decoration: BoxDecoration(
                                     shape: BoxShape.circle,
                                     color: colors[5],
                                     border:Border.all(color:colors[3],width:2)
                                 ),
                                   child: Icon(Icons.person,color: Colors.white,size: 18,),
                                 ),
                                SizedBox(width: 5,),
                                Text("${info[index]["aut_name"].trim()}",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),)
                                ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: colors[5],
                                      border:Border.all(color:colors[3],width:2)
                                  ),
                                  child: Icon(Icons.details_rounded,color: Colors.white,size: 18,),
                                ),
                                SizedBox(width: 5,),
                                Expanded(child: Text("${info[index]["aut_about"].trim()}",softWrap: true,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),))
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment:CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 30,
                          width: 60,
                          child: ElevatedButton(
                              onPressed: ()async{
                               await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context)=>addAuther(aut_id:info[index]["aut_id"])));

                               await fetchAuther();
                              }, child:Icon(Icons.edit,color: Colors.white,size: 20,),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors[5],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(color:Colors.white,width: 2),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          height: 30,
                          width: 60,
                          child: ElevatedButton(
                            onPressed: ()async{

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Are you sure you want to delete the Auther?",
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
                                                  Provider.of<AutherProvider>(context, listen: false)
                                                      .delete(info[index]["aut_id"]);
                                                  fetchAuther();
                                                  // deletebook(catedata[index]["cat_id"]);
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


                              }, child:Icon(Icons.delete,color: Colors.white,size: 20,),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors[5],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(color:Colors.white,width: 2),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                ]
                ),
              ),
            ),
          );
        }
      ),
      floatingActionButton:
      FloatingActionButton(onPressed: ()async{
         await Navigator.push(
              context,
              MaterialPageRoute(builder: (context)=>addAuther()));

         await fetchAuther();
         setState(() {

         });

      },
        backgroundColor: colors[5],
         child: Icon(Icons.add_rounded,color: Colors.white,size: 30,),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import'booklist.dart';
import 'categorylist.dart';


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
class Dashbord extends StatefulWidget{
  @override
  State<Dashbord> createState() => _DashbordState();
}

class _DashbordState extends State<Dashbord> {
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor:colors[0],
      title:Text("DashBord",textAlign: TextAlign.center,style: TextStyle(fontSize: 33),),
      centerTitle: true,
    ),body: Padding(
      padding: const EdgeInsets.all(12.0),
      child: GridView(
      scrollDirection: Axis.vertical,
      gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      children: [
        InkWell(
          onTap: (){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=>BookList()));
          },
          child: Container(
            height: 300,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color:colors[7],
              border: Border.all(color: colors[6],width: 2),
            ),
            child:Padding(
              padding: const EdgeInsets.all(23.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.book_rounded,size: 120,color: Colors.black),
                  SizedBox(height: 10,),
                  Text("Book Mangement",style: TextStyle(fontSize: 20,color: Colors.black),),
                ],
              ),
            ),

          ),
        ),
        InkWell(
          onTap: (){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=>categoriesList()));
          },
          child: Container(
            height: 300,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: colors[7],
              border: Border.all(color:colors[6],width: 2),
            ),
            child:Padding(
              padding: const EdgeInsets.all(11.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.category_rounded,size: 120,color: Colors.black),
                  SizedBox(height: 10,),
                  Text("Category Management",style: TextStyle(fontSize: 20,color: Colors.black),),
                ],
              ),
            ),
          ),
        )
      ],
        ),
    ),


  );
  }
}
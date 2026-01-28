import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
class addAuther extends StatefulWidget{
  final int? aut_id;
  addAuther({super.key, this.aut_id});
  @override
  State<addAuther> createState() => _addAutherState();
}

class _addAutherState extends State<addAuther> {
  TextEditingController Auther = TextEditingController();
  TextEditingController About = TextEditingController();

  bool showAutherError = false;
  bool showAboutError = false;



  void fetchAuther(int id) async {
    final provider = Provider.of<AutherProvider>(context, listen: false);
    final fetchedData = await provider.getOne(id);
   setState(() {
     Auther.text=fetchedData[0]['aut_name'];
     About.text=fetchedData[0]['aut_about'];
   });
  }

  @override
  void initState() {
    super.initState();
    if (widget.aut_id != null) {
      fetchAuther(widget.aut_id!);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Auther"),
        centerTitle: true,
        backgroundColor: colors[0],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top:50.0),
              child: Center(
                child: Container(
                    height: 250,
                    width: 250,
                    decoration:BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: colors[7],
                      border: Border.all(color: colors[6],width: 2),
                    ),
                    child: Icon(Icons.person_rounded,size: 150,color: Colors.black)
                ),
              ),
            ),

            SizedBox(height: 20,),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: Auther,
                decoration: InputDecoration(
                  hintText: "Auther Name",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: showAutherError?BorderSide(color: Colors.red,width: 3):BorderSide(color: colors[6],width: 3),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.red,width: 3),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.red,width: 3),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: showAboutError?BorderSide(color: Colors.red,width: 3):BorderSide(color: colors[6],width: 3),
                  ),
                ),

              ),
            ),
            if (showAutherError)
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top:1,left: 19),
                  child: Text(
                    "Add a Auther name",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),


            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: About,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: "About Auther",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: showAboutError?BorderSide(color: Colors.red,width: 3):BorderSide(color: colors[6],width: 3),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.red,width: 3),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.red,width: 3),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: showAboutError?BorderSide(color: Colors.red,width: 3):BorderSide(color: colors[6],width: 3),
                  ),
                ),

              ),
            ),
            if (showAboutError)
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top:1,left: 19),
                  child: Text(
                    "Add a About name",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(onPressed: (){

                  setState(() {
                    showAutherError = Auther.text.isEmpty;
                    showAboutError = About.text.isEmpty;
                  });

                  if (showAutherError ||showAboutError){return;}

                  if(Auther.text.isNotEmpty && About.text.isNotEmpty){
                    if(widget.aut_id!=null){
                      Map<String, dynamic> data = {
                        'aut_name': Auther.text,
                        'aut_about': About.text,
                      };
                      Provider
                          .of<AutherProvider>(context, listen: false)
                          .update(data, widget.aut_id!);
                      Auther.clear();
                      About.clear();
                      Navigator.pop(context);
                    }
                    else {
                      Map<String, dynamic> data = {
                        'aut_name': Auther.text,
                        'aut_about': About.text,
                      };
                      Provider
                          .of<AutherProvider>(context, listen: false)
                          .insert(data);
                      Auther.clear();
                      About.clear();
                      Navigator.pop(context, true);
                    }
                  }
                }, child:Text(widget.aut_id!=null? "Update Auther":"Add Auther",style: TextStyle(fontSize: 20,color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors[5],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: Colors.white,width: 2),

                  ),
                )),
              ),
            )

          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'category_provider.dart';

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

class addCategory extends StatefulWidget {
  final int? cat_id;
  addCategory({super.key, this.cat_id});

  @override
  State<addCategory> createState() => _addCategoryState();
}

class _addCategoryState extends State<addCategory> {
  TextEditingController name = TextEditingController();
  TextEditingController desc = TextEditingController();
  Map<String, dynamic>? data;


  bool shownameError = false;
  bool showdescError = false;


  @override
  void initState() {
    super.initState();
    if (widget.cat_id != null) {
      // fetch category data once for edit
      WidgetsBinding.instance.addPostFrameCallback((_) {
        fetchCategory(widget.cat_id!);
      });
    }
  }

  Future<void> fetchCategory(int catId) async {
    final provider = Provider.of<CategoryProvider>(context, listen: false);
    final fetchedData = await provider.getOne(catId);

    if (!mounted) return; // widget may be disposed
    if (fetchedData.isNotEmpty) {
      setState(() {
        name.text = fetchedData[0]['cat_name'];
        desc.text = fetchedData[0]['cat_desc'];
      });
    }
  }

  @override
  void dispose() {
    name.dispose();
    desc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cateProvider =Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors[0],
        title: Text(widget.cat_id != null ? "Edit Category" : "Add Category"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: colors[7],
                    border: Border.all(color: colors[6]),
                  ),
                  child: Icon(Icons.category_rounded, size: 120, color: Colors.black),
                ),
                SizedBox(height: 40),
                TextField(
                  controller: name,
                  decoration: InputDecoration(
                    hintText: "Enter Category Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2),
                    ),
                  ),
                ),
                if (shownameError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      "Add a category name",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                SizedBox(height: 20),
                TextField(
                  controller: desc,
                  decoration: InputDecoration(
                    hintText: "Enter Category Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2),
                    ),
                  ),
                ),
                if (showdescError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      "add a category description",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {


                             setState(() {
                                shownameError = name.text.isEmpty;
                                showdescError = desc.text.isEmpty;
                             });

                            if (shownameError ||showdescError){return;}

                      if (name.text.isNotEmpty && desc.text.isNotEmpty) {
                        data = {
                          "cat_name": name.text,
                          "cat_desc": desc.text,
                        };

                        if (widget.cat_id == null) {
                          // Add new category
                          await cateProvider.insert(data!);
                        } else {
                          // Update existing category
                          await cateProvider.update(data!, widget.cat_id!);
                        }
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Enter Category Name and Description")),
                        );
                      }
                    },
                    child: Text(
                      widget.cat_id == null ? "Add Category" : "Update Category",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors[5],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

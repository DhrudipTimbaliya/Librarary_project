import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../category/category_provider.dart';
import '../book/booklist.dart';

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

class CategoryWithBook extends StatefulWidget {
  @override
  State<CategoryWithBook> createState() => _CategoryWithBookState();
}

class _CategoryWithBookState extends State<CategoryWithBook> {
  List<Map<String, dynamic>> catedata = [];

  Future<void> fetchcategory({String? keyword}) async {
    try {
      final provider =
      Provider.of<CategoryProvider>(context, listen: false);

      final fetchedData =
      await provider.getAll(keyword: keyword);

      setState(() {
        catedata = fetchedData;
      });
    } catch (e) {
      debugPrint("Error fetching data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchcategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: colors[0],
        centerTitle: true,
        title: Text(
          "Book Category",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),

      body: catedata.isEmpty
          ? Center(
        child: Text(
          "No Category Record Found",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: catedata.length,
          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            final cat = catedata[index];

            return InkWell(
              borderRadius: BorderRadius.circular(25),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookList(
                      cateid: cat['cat_id'],
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: colors[7],
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: colors[6],
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment:MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/image/bookimage.png",height: 70,width: 70,),

                      SizedBox(height: 15),
                      Text(
                        cat['cat_name'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

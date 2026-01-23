import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'addbook.dart';
import 'category_provider.dart';
import 'provider.dart';
import 'extra/db_helper.dart';
import 'showbook.dart';
import 'detiles.dart';
import 'dashboard.dart';
import 'categorylist.dart';
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataSet()),
        ChangeNotifierProvider(create: (_) => GetImageProvider()),
        ChangeNotifierProvider(create: (_) => PdfProvider()),
        ChangeNotifierProvider(create: (_) => PickedDate()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),

      ],
      child: MyApp(),
    ),
  );
}
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

class MyApp extends StatelessWidget {
   MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liberary Mangement',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Dashbord(),
    );
  }
}

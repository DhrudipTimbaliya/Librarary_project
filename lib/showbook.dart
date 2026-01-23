import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class ShowBook extends StatefulWidget {
  final File pdf;
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
   ShowBook({super.key, required this.pdf});

  @override
  State<ShowBook> createState() => _ShowBookState();
}

class _ShowBookState extends State<ShowBook> {
  late PdfController pdfController;

  @override
  void initState() {
    super.initState();
     pdfController = PdfController(
      document: PdfDocument.openFile(widget.pdf.path),
    );
  }

  @override
  void dispose() {
    pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("PDF Viewer"),
        centerTitle: true,
        backgroundColor: widget.colors[0],
      ),
      body: Padding(
        padding:  EdgeInsets.all(15.0),
        child: Container(
          color:widget.colors[7],
          child: PdfView(
            controller: pdfController,
          ),
        ),
      ),
    );
  }
}

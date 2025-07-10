import 'package:flutter/material.dart';
import 'package:resize/resize.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({super.key});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
         backgroundColor: Colors.white,
          body: Container(
        padding: EdgeInsets.only(top: 19.h, left: 16.w, right: 16.w),
        child: Column(
          children: [],
        ),
      )),
    );
  }
}

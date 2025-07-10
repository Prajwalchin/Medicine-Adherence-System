import 'package:flutter/material.dart';

void notify(
    {required String? text,
    Color? color,
    SnackBarAction? snackBarAction,
    required BuildContext context}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      text ?? "",
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: color ?? Colors.redAccent,
    duration: const Duration(seconds: 3),
    action: snackBarAction,
  ));
}

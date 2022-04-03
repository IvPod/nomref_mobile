import 'package:flutter/material.dart';

showSnackBar(
  BuildContext context,
  String text, {
  bool isError = false,
  bool showProgress = false,
}) {
  final snackBar = SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text),
        if (showProgress) CircularProgressIndicator(),
      ],
    ),
    backgroundColor: isError ? Colors.red : Colors.grey,
  );
  Scaffold.of(context).showSnackBar(snackBar);
}

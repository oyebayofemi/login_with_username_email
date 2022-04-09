import 'package:flutter/material.dart';

showSnackBar(BuildContext context, String text) {
  final snackBar = SnackBar(backgroundColor: Colors.red, content: Text(text));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

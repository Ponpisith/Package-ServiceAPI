import 'package:flutter/material.dart';

class HandleError {
  final BuildContext context;
  final String title;
  final String content;

  HandleError(
      {required this.context, required this.title, required this.content});

  Future<void> showError(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: Text(title),
          content: Text(content),
        );
      },
    );
  }
}

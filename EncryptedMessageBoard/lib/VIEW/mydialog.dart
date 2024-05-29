import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDialog {
  // Progress Wheel Starts
  static void circularProgressStart(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => Center(child: CircularProgressIndicator()));
  }

  // Progress Wheel Ends
  static void circularProgressEnd(BuildContext context) {
    Navigator.pop(context);
  }

  // Alert Dialog with Title and Content
  static void info({
    BuildContext context,
    String title,
    String content,
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

void popUpAlert(BuildContext context, bool showCancelButton, String title,
    String message, Function() onPressed) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(message),
            ],
          ),
        ),
        actions: <Widget>[
          if (showCancelButton)
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Closes the dialog without performing any action
              },
            ),
          TextButton(
            child: Text('OK'),
            onPressed: onPressed,
          ),
        ],
      );
    },
  );
}

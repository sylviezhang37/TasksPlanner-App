import 'package:TasksPlanner/utilities/constants.dart';
import 'package:flutter/material.dart';

TextEditingController _textFieldController = TextEditingController();

Future<void> displayTextInputDialog(
  BuildContext context,
  String title,
  Function(BuildContext, String) onPressCallBack,
) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        alignment: Alignment.center,
        title: Text(title, style: kdialogTitleTextStyle),
        content: TextField(
          autofocus: true,
          controller: _textFieldController,
          decoration: InputDecoration(hintText: "List Name"),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('CANCEL', style: kdialogActionTextStyle),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text('OK', style: kdialogActionTextStyle),
            onPressed: () async {
              if (_textFieldController.text.isNotEmpty) {
                await onPressCallBack(context, _textFieldController.text);
                _textFieldController.clear();
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ],
      );
    },
  );
}

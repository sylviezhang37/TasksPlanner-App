import 'package:flutter/material.dart';

TextEditingController _textFieldController = TextEditingController();

Future<void> displayTextInputDialog(
  BuildContext context,
  Function(BuildContext, String) addTaskListCallBack,
) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        alignment: Alignment.center,
        title: Text('Add New List:'),
        content: TextField(
          controller: _textFieldController,
          decoration: InputDecoration(hintText: "List Name"),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('CANCEL'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text('OK'),
            onPressed: () async {
              if (_textFieldController.text.isNotEmpty) {
                await addTaskListCallBack(context, _textFieldController.text);
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

import 'package:flutter/material.dart';
import '../tasks/tasks_screen.dart';

TextEditingController _textFieldController = TextEditingController();

Future<void> displayTextInputDialog(
  BuildContext context,
  Function(String) addTaskListCallBack,
  int numOfTaskLists,
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
            onPressed: () {
              if (_textFieldController.text.isNotEmpty) {
                addTaskListCallBack(_textFieldController.text);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TasksScreen(
                              listIndex: numOfTaskLists,
                            )));
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

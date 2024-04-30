import 'package:TasksPlanner/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:TasksPlanner/models/task.dart';
import 'package:TasksPlanner/models/task_list.dart';
import 'package:TasksPlanner/tasks/tasks_screen.dart';
import 'package:flutter/widgets.dart';

final TextEditingController textController = TextEditingController();

Future<dynamic> searchDialog(
    BuildContext context, List<TaskList> userLists) async {
  List<Task> allTasks = userLists.expand((list) => list.tasks).toList();
  List<Task> activeTasks = allTasks;

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        void textFieldOnChanged(String value) {
          final suggestions = allTasks.where((task) {
            final name = task.name.toLowerCase();
            final input = value.toLowerCase();
            return name.contains(input);
          }).toList();

          setState(() {
            activeTasks = suggestions;
          });
        }

        return AlertDialog(
          // title: Text('Your Dialog Title'),
          content: SizedBox(
            width: double.maxFinite,
            height: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              // mainAxisSize:
              //     MainAxisSize.min, // Use 'min' to fit the content size
              children: <Widget>[
                kSpacing,
                Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(30),
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      fillColor: Theme.of(context).colorScheme.primary,
                      prefixIcon: Icon(Icons.search,
                          color: Theme.of(context).colorScheme.primary),
                      hintText: "search task",
                      focusedBorder: kOutlineBorder,
                      border: kOutlineBorder,
                    ),
                    onChanged: (value) {
                      textFieldOnChanged(value);
                    },
                  ),
                ),
                kSpacing,
                Expanded(
                  child: ListView.builder(
                      itemCount: activeTasks.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(activeTasks[index].name),
                          onTap: () {
                            textController.clear();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TasksScreen(
                                        listID: activeTasks[index].listId)));
                          },
                        );
                      }),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: Text(
                  'CANCEL',
                  style: kdialogActionTextStyle,
                ),
                onPressed: () {
                  textController.clear();
                  Navigator.of(context).pop();
                }),
          ],
        );
      });
    },
  );
}

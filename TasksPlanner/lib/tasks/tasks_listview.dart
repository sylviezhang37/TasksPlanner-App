import 'package:TasksPlanner/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/list_service.dart';
import '../models/task.dart';
import '../models/task_list.dart';
import '../models/user_lists.dart';

// ignore: must_be_immutable
class TasksListView extends StatelessWidget {
  TaskList? taskList;

  TasksListView({this.taskList});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: ListService().allLists(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong.");
        }
        // if (!snapshot.hasData) {
        //   return const Center(child: CircularProgressIndicator());
        // }

        List<Task> tasks = [];
        List<TaskList> userLists = UserLists.fromQuerySnapshot(snapshot);

        if (taskList != null) {
          for (TaskList currentTaskList in userLists) {
            if (taskList!.id == currentTaskList.id) {
              tasks = currentTaskList.tasks;
            }
          }
        } else {
          tasks = userLists.expand((taskList) => taskList.tasks).toList();
        }

        return ListView.separated(
          itemCount: tasks.length,
          separatorBuilder: (context, index) {
            return kDottedLine;
          },
          itemBuilder: (context, index) {
            // add a dotted line at the end
            // if (index == tasks.length) {
            //   return kDottedLine;
            // }
            return Dismissible(
              key: Key(tasks[index].name),
              onDismissed: (direction) async {
                TaskList taskList = userLists.firstWhere((currentTaskList) =>
                    tasks[index].listId == currentTaskList.id);
                taskList.remove(tasks[index]);
                ListService().updateTaskListMetadata(taskList);
              },
              // show a colored box as user swipes
              background: Container(
                  color: Theme.of(context).colorScheme.primaryContainer),
              child: CustomListTile(
                checked: tasks[index].done,
                taskName: tasks[index].name,
                checkBoxCallBack: (checkBoxState) async {
                  tasks[index].changeDone();
                  TaskList taskList = userLists.firstWhere((currentTaskList) =>
                      tasks[index].listId == currentTaskList.id);
                  ListService().updateTaskListMetadata(taskList);
                },
              ),
            );
          },
        );
      },
    );
  }
}

class CustomListTile extends StatelessWidget {
  final bool checked;
  final String taskName;
  final Function(bool?) checkBoxCallBack;

  CustomListTile({
    required this.checked,
    required this.taskName,
    required this.checkBoxCallBack,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle taskListTileTextStyle = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w500,
      decoration: checked ? TextDecoration.lineThrough : null,
      color:
          checked ? Colors.grey[500] : Theme.of(context).colorScheme.onSurface,
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(
          taskName,
          style: taskListTileTextStyle,
        ),
        // onLongPress: longPressCallBack,
        trailing: Checkbox(
          side: BorderSide(
              color: Theme.of(context).colorScheme.onSurface, width: 1.5),
          activeColor: Theme.of(context).colorScheme.onSurface,
          value: checked,
          onChanged: checkBoxCallBack,
        ),
      ),
    );
  }
}

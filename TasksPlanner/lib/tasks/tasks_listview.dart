import 'package:TasksPlanner/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/firestore_service.dart';
import '../models/task.dart';
import '../models/task_list.dart';
import '../models/user_lists.dart';

class TasksListView extends StatefulWidget {
  TaskList? taskList;

  TasksListView({super.key, this.taskList});

  @override
  _TasksListViewState createState() => _TasksListViewState();
}

class _TasksListViewState extends State<TasksListView> {

  List<Task> tasks = [];
  List<TaskList> userLists = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: ListService().allLists(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong.");
        } else if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        userLists = UserLists.getQuerySnapshot(snapshot);
        if (widget.taskList != null) {
          for (TaskList currentTaskList in userLists) {
            if (widget.taskList!.id == currentTaskList.id) {
              tasks = currentTaskList.tasks.toList();
            }
          }
        } else {
          tasks = userLists.expand((taskList) => taskList.tasks.toList()).toList();
        }

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final isLastItem = (index == tasks.length -1);
            return Dismissible(
              key: Key(tasks[index].name),
              onDismissed: (direction) async {
                TaskList taskList = userLists.firstWhere((currentTaskList) =>
                    tasks[index].listId == currentTaskList.id);
                taskList.removeTask(tasks[index]);
                ListService().updateTaskListMetadata(taskList);
              },
              // show a colored box as user swipes
              background: Container(
                  color: Theme.of(context).colorScheme.primaryContainer),
              child: Column(
                children: [
                  CustomListTile(
                    checked: tasks[index].done,
                    taskName: tasks[index].name,
                    checkBoxCallBack: (checkBoxState) async {
                      tasks[index].changeDone();
                      TaskList taskList = userLists.firstWhere((currentTaskList) =>
                          tasks[index].listId == currentTaskList.id);
                      ListService().updateTaskListMetadata(taskList);
                    },
                  ),
                  if (!isLastItem) kDottedLine,
                ],
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
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          softWrap: false,
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

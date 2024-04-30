import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:TasksPlanner/tasks/task_tile.dart';
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
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        List<Task> tasks = [];
        List<TaskList> userLists = UserLists.fromQuerySnapshot(snapshot);

        if (taskList != null) {
          print("taskList is not null");
          for (TaskList currentTaskList in userLists) {
            if (taskList!.id == currentTaskList.id) {
              tasks = currentTaskList.tasks;
            }
          }
        } else {
          print("taskList is null");
          tasks = userLists.expand((taskList) => taskList.tasks).toList();
        }

        return ListView.builder(
          itemBuilder: (context, index) {
            return TaskTile(
              isChecked: tasks[index].done,
              taskName: tasks[index].name,
              checkBoxCallBack: (checkBoxState) async {
                tasks[index].changeDone();
                TaskList taskList = userLists.firstWhere((currentTaskList) =>
                    tasks[index].listId == currentTaskList.id);
                ListService().updateTaskListMetadata(taskList);
              },
              longPressDelete: () async {
                TaskList taskList = userLists.firstWhere((currentTaskList) =>
                    tasks[index].listId == currentTaskList.id);
                taskList.remove(tasks[index]);
                ListService().updateTaskListMetadata(taskList);
              },
            );
          },
          itemCount: tasks.length,
        );
      },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:TasksPlanner/tasks/task_tile.dart';
import 'package:flutter/material.dart';

import '../models/list_service.dart';
import '../models/task.dart';
import '../models/task_list.dart';
import '../models/user_lists.dart';


// ignore: must_be_immutable
class TasksListView extends StatelessWidget {
  int listIndex;

  TasksListView({required this.listIndex});

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

        List<TaskList> userLists = UserLists.fromQuerySnapshot(snapshot);

        List<Task> tasks = listIndex == -1
            ? userLists.expand((taskList) => taskList.tasks).toList()
            : userLists[listIndex].tasks;

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

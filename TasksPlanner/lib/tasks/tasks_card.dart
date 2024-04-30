import 'package:TasksPlanner/tasks/tasks_listview.dart';
import 'package:flutter/material.dart';
import '../models/task_list.dart';
import '../models/user_lists.dart';
import '../utilities/constants.dart';

class TasksListCard extends StatelessWidget {
  TaskList? taskList;
  late String taskListName;
  late String taskListDoneFraction;

  TasksListCard({
    super.key,
    required this.taskList,
  }) {
    taskListName = taskList!.name;
    taskListDoneFraction = taskList!.taskDoneFraction();
  }

  TasksListCard.forAllTaskLists({super.key, required userLists}) {
    {
      taskListName = "All Tasks";
      taskListDoneFraction = UserLists.taskDoneFraction(userLists);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: kHeaderPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 40.0),
                  Row(children: <Widget>[
                    Text(
                      taskListName,
                      style: kHeaderTextStyle,
                    ),
                    kSpacing,
                  ]),
                  Text(
                    '$taskListDoneFraction Completed',
                    style: kBodyTextStyle,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                  padding: kTaskListCardPadding,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: kTaskListCardRadius,
                      boxShadow: kTaskListBoxShadow),
                  child: taskList != null
                      ? TasksListView(taskList: taskList)
                      : TasksListView()),
            ),
          ]),
    );
  }
}

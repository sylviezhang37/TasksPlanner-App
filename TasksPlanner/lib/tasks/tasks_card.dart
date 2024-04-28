import 'package:dobee/tasks/tasks_listview.dart';
import 'package:flutter/material.dart';
import '../models/task_list.dart';
import '../models/user_lists.dart';
import '../utilities/constants.dart';

// ignore: must_be_immutable
class TasksListCard extends StatelessWidget {
  List<TaskList> userLists;
  int listIndex;
  late String taskListName;
  late String taskListDoneFraction;

  TasksListCard({
    required this.userLists,
    required this.listIndex,
  }) {
    taskListName = userLists[listIndex].name;
    taskListDoneFraction = userLists[listIndex].taskDoneFraction();
  }

  TasksListCard.withoutIndex({super.key, required this.userLists}) : listIndex = -1 {
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
                    style: kSubtitleTextStyle,
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
                child: TasksListView(
                  listIndex: listIndex,
                ),
              ),
            ),
          ]),
    );
  }
}

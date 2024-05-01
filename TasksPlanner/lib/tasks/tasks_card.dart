import 'package:TasksPlanner/tasks/tasks_listview.dart';
import 'package:flutter/material.dart';
import '../models/task_list.dart';
import '../models/user_lists.dart';
import '../utilities/constants.dart';

class TasksListCard extends StatelessWidget {
  TaskList? taskList;
  late String listName;
  late String listDoneFraction;

  TasksListCard({
    super.key,
    required this.taskList,
  }) {
    listName = taskList!.name;
    listDoneFraction = taskList!.taskDoneFraction();
  }

  TasksListCard.forAllTaskLists({super.key, required userLists}) {
    {
      listName = "All Tasks";
      listDoneFraction = UserLists.taskDoneFraction(userLists);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 40.0),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 30, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 50, 0),
                  child: Text(
                    listName,
                    style: kListHeaderTextStyleDark,
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       listName,
                  //       style: kListHeaderTextStyleDark,
                  //     ),
                  //     IconButton(
                  //         onPressed: deleteCallBack,
                  //         icon: Icon(Icons.delete_outline_rounded))
                  //   ],
                  // ),
                ),
                Card(
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(.8),
                  elevation: 0.5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                    child: Text(
                      '$listDoneFraction completed',
                      style: kBodyTextStyleDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: kTaskListTilePadding,
              child: taskList != null
                  ? TasksListView(taskList: taskList)
                  : TasksListView(),
            ),
          ),
        ],
      ),
    );
  }
}

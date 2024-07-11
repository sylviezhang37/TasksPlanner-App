import 'package:TasksPlanner/components/tasks/tasks_listview.dart';
import 'package:TasksPlanner/components/text_input_dialog.dart';
import 'package:TasksPlanner/models/firestore_service.dart';
import 'package:flutter/material.dart';
import '../../models/task_list.dart';
import '../../models/user_lists.dart';
import '../../utilities/constants.dart';

class TasksListCard extends StatelessWidget {
  TaskList? taskList;
  late String listName;
  late String listDoneFraction;

  TasksListCard({
    super.key,
    required this.taskList,
  }) {
    listName = taskList!.name;
    listDoneFraction = taskList!.completionFraction();
  }

  TasksListCard.forAllTaskLists({super.key, required userLists}) {
    {
      listName = "All Tasks";
      listDoneFraction = UserLists.completionFraction(userLists);
    }
  }

  void changeListName(BuildContext context, String listName) {
    ListService().changeListName(taskList!, listName);
    Navigator.pop(context);
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          listName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                          style: kListHeaderTextStyleDark,
                        ),
                      ),
                      if (taskList != null)
                        IconButton(
                            onPressed: () {
                              displayTextInputDialog(
                                context,
                                "List Name:",
                                changeListName,
                              );
                            },
                            icon: Icon(Icons.border_color_rounded))
                    ],
                  ),
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

import 'package:TasksPlanner/components/popup_alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:TasksPlanner/tasks/tasks_screen.dart';
import 'package:flutter/material.dart';
import '../models/firestore_service.dart';
import '../models/task_list.dart';
import '../models/user_lists.dart';
import '../utilities/constants.dart';

class HomePageMyLists extends StatefulWidget {
  const HomePageMyLists({super.key});

  @override
  State<HomePageMyLists> createState() => _HomePageMyLists();
}

class _HomePageMyLists extends State<HomePageMyLists> {
  void deleteList(List<TaskList> userLists, String taskListID) {
    ListService().deleteTaskList(userLists, taskListID);
  }

  Future<bool?> confirmDismiss(DismissDirection direction) {
    return popUpConfirmWindow(
      context,
      "Delete this list?",
      "Click 'OK' to confirm, or 'CANCEL' to cancel.",
    );
  }

  Widget emptyUserListsView() => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.3,
                ),
                Text(
                  "You don't have a list yet.\nClick 'Add List' below to get started!",
                  style: kBodyTextStyleDark.copyWith(fontSize: 15.0),
                ),
                const Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Icon(Icons.arrow_downward_rounded),
                ),
              ],
            )
          ]);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: ListService().allLists(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          List<TaskList> userLists = UserLists.getQuerySnapshot(snapshot);

          if (userLists.isEmpty) {
            return emptyUserListsView();
          } else {
            return ListView.builder(
                itemCount: userLists.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) async {
                      deleteList(userLists, userLists[index].id);
                    },
                    confirmDismiss: (DismissDirection direction) {
                      return confirmDismiss(direction);
                    },
                    child: Align(
                        heightFactor: 0.6,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey[500]!,
                                  spreadRadius: 0,
                                  blurRadius: 4)
                            ],
                          ),
                          child: ElevatedButton(
                            style: kHomePageButtonStyleRandom(index),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TasksScreen(
                                            listID: userLists[index].id,
                                          )));
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  // This expands the inner row that contains text and icon.
                                  child: Container(
                                    margin: kTaskListCardPadding,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child:Text(
                                            userLists[index].name,
                                            style: kHomePageSubheaderTextStyle,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            softWrap: false,
                                          ),
                                        ),
                                        kListCardArrow,
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                  );
                });
          }
        }
        return emptyUserListsView();
      },
    );
  }
}

import 'package:TasksPlanner/components/search_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../navigation/nav_bar_item.dart';
import '../screens/settings_screen.dart';
import '../screens/home_screen.dart';
import '../models/firestore_service.dart';
import '../models/task_list.dart';
import '../models/user_lists.dart';
import '../navigation/navigation_bar.dart';
import '../navigation/menu_drawer.dart';
import '../components/add_task_dialog.dart';
import '../tasks/tasks_card.dart';

class TasksScreen extends StatefulWidget {
  String? listID;

  TasksScreen({super.key, this.listID});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: ListService().allLists(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong.");
        }

        List<TaskList> userLists = UserLists.getQuerySnapshot(snapshot);

        TaskList? taskList;
        if (widget.listID != null) {
          try {
            taskList =
                userLists.firstWhere((element) => element.id == widget.listID);
          } catch (e) {
            // Log error or handle the fact that no task list was found
            taskList = null;
          }
        }

        // show input dialog for user to add task
        void bottomInputDialog(List<TaskList> userLists) {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) => SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: AddTaskDialog(
                selectedTaskList:
                    widget.listID == null ? userLists[0] : taskList!,
              ),
            ),
            isScrollControlled: true,
          );
        }

        void addTaskList(BuildContext context, String taskListName) async {
          String listID = await ListService().addTaskList(taskListName);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TasksScreen(
                        listID: listID,
                      )));
        }

        void _onItemTapped(int index) {
          setState(() {
            widget.listID = userLists[index].id;
          });
        }

        List<NavBarItem> navBarItems = [
          NavBarItem(
            icon: Icon(Icons.menu),
            onTap: () => scaffoldKey.currentState?.openDrawer(),
          ),
          NavBarItem(
            icon: Icon(Icons.search),
            onTap: () => {searchDialog(context, userLists)},
          ),
          NavBarItem(
            icon: Icon(Icons.home),
            onTap: () => Navigator.pushNamed(context, HomePage.id),
          ),
          NavBarItem(
            icon: Icon(Icons.settings),
            onTap: () => Navigator.pushNamed(context, SettingsScreen.id),
          ),
        ];

        return Scaffold(
          backgroundColor: Color(0xffE2F4A6),
          key: scaffoldKey,
          extendBody: true,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.onSurface,
            shape: const CircleBorder(),
            onPressed: () {
              if (taskList != null) {
                bottomInputDialog(userLists);
              }
            },
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar: CustomNavigationBar(
            items: navBarItems,
          ),
          body: Stack(
            children: <Widget>[
              Container(
                child: widget.listID != null && taskList != null
                    ? TasksListCard(
                        taskList: taskList,
                      )
                    : TasksListCard.forAllTaskLists(
                        userLists: userLists,
                      ),
              ),
            ],
          ),
          drawer: MenuDrawer(
            onItemTapped: _onItemTapped,
            addTaskListCallBack: addTaskList,
          ),
        );
      },
    );
  }
}

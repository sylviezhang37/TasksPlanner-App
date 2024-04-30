import 'package:TasksPlanner/components/popup_alert.dart';
import 'package:TasksPlanner/components/search_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../navigation/nav_bar_item.dart';
import '../screens/settings_screen.dart';
import '../screens/home_page.dart';
import '../models/list_service.dart';
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

  void initState() {
    super.initState();
  }

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

        TaskList? taskList;
        if (widget.listID != null) {
          taskList =
              userLists.where((element) => element.id == widget.listID).first;
        }

        void userInputDialog(List<TaskList> userLists) {
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
          key: scaffoldKey,
          //scaffold’s body visible through the bottom navigation bar’s notch
          extendBody: true,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            shape: const CircleBorder(),
            onPressed: () {
              userInputDialog(userLists);
            },
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar: CustomNavigationBar(
            items: navBarItems,
          ),
          body: Stack(
            children: <Widget>[
              Center(
                child: widget.listID != null
                    ? TasksListCard(
                        taskList: taskList!,
                      )
                    : TasksListCard.forAllTaskLists(
                        userLists: userLists,
                      ),
              ),
            ],
          ),
          drawer: MenuDrawer(
            // selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
            addTaskListCallBack: addTaskList,
          ),
        );
      },
    );
  }
}

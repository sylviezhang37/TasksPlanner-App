import 'package:TasksPlanner/components/popup_alert.dart';
import 'package:TasksPlanner/utilities/constants.dart';
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
  final int listIndex;

  // making startingIndex optional and default to 0 (default to-do screen)
  TasksScreen({super.key, this.listIndex = -1});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  late int _selectedIndex;

  // first method called after the widget is created but before build is called
  // initialize state that depends on widget properties
  void initState() {
    super.initState();
    _selectedIndex = widget.listIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void userInputDialog(List<TaskList> userLists) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => SingleChildScrollView(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AddTaskDialog(
          selectedTaskList:
              _selectedIndex == -1 ? userLists[0] : userLists[_selectedIndex],
        ),
      ),
      isScrollControlled: true,
    );
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

        List<NavBarItem> navBarItems = [
          NavBarItem(
            icon: Icon(Icons.menu),
            onTap: () => scaffoldKey.currentState?.openDrawer(),
          ),
          NavBarItem(
            icon: Icon(Icons.share),
            onTap: () {
              popUpAlert(context, false, kPopupTitle, "Come back later!", () {
                Navigator.of(context).pop();
              });
            },
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
                child: _selectedIndex != -1
                    ? TasksListCard(
                        userLists: userLists,
                        listIndex: _selectedIndex,
                      )
                    : TasksListCard.withoutIndex(
                        userLists: userLists,
                      ),
              ),
            ],
          ),
          drawer: MenuDrawer(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
          ),
        );
      },
    );
  }
}

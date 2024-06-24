import 'package:TasksPlanner/components/search_dialog.dart';
import 'package:TasksPlanner/navigation/nav_bar_item.dart';
import 'package:TasksPlanner/navigation/navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/firestore_service.dart';
import '../components/text_input_dialog.dart';
import '../screens/settings_screen.dart';
import '../tasks/tasks_screen.dart';
import '../models/task_list.dart';
import '../models/user_lists.dart';
import '../utilities/constants.dart';
import '../tasks/homepage_task_lists.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home_page';
  final String? previousPageID;

  const HomePage({super.key, String this.previousPageID = "log_in"});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  late Text welcomeText;
  late List<TaskList> userLists;

  @override
  void initState() {
    super.initState();
    welcomeText = Text(
      widget.previousPageID == "log_in" ? "Welcome Back :)" : "Welcome!",
      style: kHPHeaderTextStyle,
    );
  }

  /*
  Navigation bar objects at the bottom of screen
   */
  List<NavBarItem> navBarItems(
          BuildContext context, List<TaskList> userLists) =>
      [
        NavBarItem(
          icon: const Icon(Icons.search),
          onTap: () => {searchDialog(context, userLists)},
        ),
        NavBarItem(
            icon: const Icon(Icons.format_list_bulleted_add),
            onTap: () => displayTextInputDialog(
                  context,
                  "New List:",
                  addTaskList,
                )),
        NavBarItem(
          icon: const Icon(Icons.settings),
          onTap: () => Navigator.pushNamed(context, SettingsScreen.id),
        ),
      ];

  void addTaskList(BuildContext context, String taskListName) async {
    String listID = await ListService().addTaskList(taskListName);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => TasksScreen(listID: listID)));
  }

  IconButton topRightArrowButton() => customIconButton(
      () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => TasksScreen())),
      kOutArrowRight);

  @override
  Widget build(BuildContext context) {
    if (ListService().currentUser == null) {
      return const Scaffold(
        body: Text("Please log in to view this page."),
      );
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: ListService().allLists(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text("Error: ${snapshot.error}"),
                ),
              );
            }
          }

          userLists = UserLists.getQuerySnapshot(snapshot);

          return Scaffold(
            extendBody: true,
            bottomNavigationBar: CustomNavigationBar(
              items: navBarItems(context, userLists),
            ),
            body: Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: kToolbarHeight,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.07,
                          vertical: MediaQuery.of(context).size.width * 0.035),
                      child: welcomeText,
                    ),
                    Container(
                      // color: Colors.grey, // for debugging
                      height: MediaQuery.of(context).size.width * 0.3,
                      margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.06),
                      child: Stack(children: [
                        if (!userLists.isEmpty)
                          Positioned(
                            top: MediaQuery.of(context).size.width * 0.025,
                            left: MediaQuery.of(context).size.width * 0.73,
                            child: topRightArrowButton(),
                          ),
                        Positioned(
                          top: MediaQuery.of(context).size.width * 0.04,
                          left: MediaQuery.of(context).size.width * 0.01,
                          child: const Text(
                            style: kHPAllTasksTextStyle,
                            'Tasks Completed',
                          ),
                        ),
                        Positioned(
                            top: MediaQuery.of(context).size.width * 0.17,
                            left: 0,
                            child: LinearPercentIndicator(
                              barRadius: const Radius.circular(3.0),
                              lineHeight: 8.0,
                              width: MediaQuery.of(context).size.height * 0.14,
                              percent:
                                  UserLists.completionPercentage(userLists),
                              backgroundColor:
                                  kThemeDataDark.colorScheme.onBackground,
                              progressColor:
                                  kThemeDataDark.colorScheme.onSurface,
                              trailing: Text(
                                  UserLists.completionFraction(userLists),
                                  style: kBodyTextStyleDark),
                            ))
                      ]),
                    ),
                    Expanded(
                      child: Center(
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: const HomePageTaskLists()),
                      ),
                    ),
                  ]),
            ),
          );
        });
  }
}

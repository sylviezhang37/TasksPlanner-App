import 'package:TasksPlanner/components/search_dialog.dart';
import 'package:TasksPlanner/navigation/nav_bar_item.dart';
import 'package:TasksPlanner/navigation/navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/list_service.dart';
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

  HomePage({String this.previousPageID = "log_in"});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  void addTaskList(BuildContext context, String taskListName) async {
    String listID = await ListService().addTaskList(taskListName);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => TasksScreen(listID: listID)));
  }

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
        if (snapshot.hasError) {
          return const Text("Something went wrong.");
        }

        List<TaskList> userLists = [];
        userLists = UserLists.fromQuerySnapshot(snapshot);

        List<NavBarItem> navBarItems = [
          NavBarItem(
            icon: Icon(Icons.search),
            onTap: () => {searchDialog(context, userLists)},
          ),
          NavBarItem(
              icon: Icon(Icons.format_list_bulleted_add),
              onTap: () => displayTextInputDialog(
                    context,
                    "New List:",
                    addTaskList,
                  )),
          NavBarItem(
            icon: Icon(Icons.settings),
            onTap: () => Navigator.pushNamed(context, SettingsScreen.id),
          ),
        ];

        Text welcomeText = Text(
          widget.previousPageID == "log_in" ? "Welcome Back :)" : "Welcome!",
          style: kHomePageHeaderTextStyle,
        );

        return Scaffold(
          extendBody: true,
          bottomNavigationBar: CustomNavigationBar(
            items: navBarItems,
          ),
          body: SafeArea(
            child: Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.07,
                          vertical: MediaQuery.of(context).size.width * 0.035),
                      child: welcomeText,
                    ),
                    Container(
                      // color: Colors.grey, // for debugging
                      height: MediaQuery.of(context).size.width * 0.35,
                      margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.06),
                      child: Stack(children: [
                        Positioned(
                          top: MediaQuery.of(context).size.width * 0.025,
                          left: MediaQuery.of(context).size.width * 0.73,
                          child: IconButton(
                            icon: Icon(Icons.arrow_outward_rounded),
                            iconSize: MediaQuery.of(context).size.width * 0.1,
                            color: kThemeDataDark.colorScheme.onSurface,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TasksScreen()));
                            },
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.width * 0.04,
                          left: MediaQuery.of(context).size.width * 0.01,
                          child: Text(
                            style: TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                                color: kThemeDataDark.colorScheme.onSurface),
                            'Tasks Completed',
                          ),
                        ),
                        Positioned(
                            top: MediaQuery.of(context).size.width * 0.17,
                            left: 0,
                            child: LinearPercentIndicator(
                              barRadius: Radius.circular(3.0),
                              lineHeight: 8.0,
                              width: MediaQuery.of(context).size.height * 0.14,
                              percent: UserLists.taskDonePercentage(userLists),
                              backgroundColor:
                                  kThemeDataDark.colorScheme.onBackground,
                              progressColor:
                                  kThemeDataDark.colorScheme.onSurface,
                              trailing: Text(
                                  UserLists.taskDoneFraction(userLists),
                                  style: kBodyTextStyleDark),
                            ))
                      ]),
                    ),
                    kSpacing,
                    Expanded(
                      child: Center(
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: HomePageMyLists()),
                      ),
                    ),
                  ]),
            ),
          ),
        );
      },
    );
  }
}

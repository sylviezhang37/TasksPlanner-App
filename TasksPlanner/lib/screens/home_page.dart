import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/list_service.dart';
import '../components/text_input_dialog.dart';
import '../screens/settings_screen.dart';
import '../tasks/tasks_screen.dart';
import '../models/task_list.dart';
import '../models/user_lists.dart';
import '../utilities/constants.dart';
import '../tasks/homepage_my_lists.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home_page';

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (ListService().currentUser == null) {
      return Scaffold(
        body: Text("Please log in to view this page."),
      );
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: ListService().allLists,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong.");
        }
        if (!snapshot.hasData) {
          print("error in home page");
          return const Center(child: CircularProgressIndicator());
        }

        List<TaskList> userLists = UserLists.fromQuerySnapshot(snapshot);
        // List<NavBarItem> navBarItems = [
        //   NavBarItem(
        //     icon: Icon(Icons.search),
        //     onTap: () {},
        //   ),
        //   NavBarItem(
        //     icon: Icon(Icons.settings),
        //     onTap: () => Navigator.pushNamed(context, SettingsScreen.id),
        //   ),
        // ];

        return Scaffold(
          // bottomNavigationBar: CustomNavigationBar(
          //   items: navBarItems,
          // ),
          floatingActionButton: ElevatedButton(
            style: kHomePageButtonStyleLight,
            onPressed: () {
              displayTextInputDialog(
                context,
                ListService().addTaskList,
                userLists.length,
              );
            },
            child: const Text(
              "Add List",
              style: kSubtitleTextStyle,
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniCenterDocked,
          body: SafeArea(
            child: Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        "Welcome Back.",
                        style: kHomePageHeaderTextStyle,
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.width * 0.5,
                        child: ElevatedButton(
                          style: kHomePageButtonStyleDark,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TasksScreen()));
                          },
                          child: Stack(children: [
                            Positioned(
                                top: MediaQuery.of(context).size.width * 0.07,
                                left: MediaQuery.of(context).size.width * 0.38,
                                child: Image.asset('assets/clicking-post.png',
                                    width: MediaQuery.of(context).size.width *
                                        0.45)),
                            Positioned(
                              top: MediaQuery.of(context).size.width * 0.1,
                              left: 10,
                              child: Text(
                                style: TextStyle(
                                    fontSize: 25.0,
                                    fontFamily: 'fonts/Lato-Bold.ttf',
                                    color: kThemeDataDark
                                        .colorScheme.onSurfaceVariant),
                                'Tasks\nCompleted',
                              ),
                            ),
                            Positioned(
                                top: 130,
                                left: 0,
                                child: LinearPercentIndicator(
                                  barRadius: Radius.circular(2.0),
                                  width: 120,
                                  percent:
                                      UserLists.taskDonePercentage(userLists),
                                  backgroundColor: Color(0xff3B64F0),
                                  progressColor: Colors.white,
                                  trailing: Text(
                                      UserLists.taskDoneFraction(userLists),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'fonts/Lato-Bold.ttf',
                                      )),
                                ))
                          ]),
                        ),
                      ),
                    ),
                    kSpacing,
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        "My Lists",
                        style: kHomePageSubheaderTextStyle,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: HomePageMyLists()),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(0)),
                              child: Icon(Icons.settings),
                              onPressed: () {
                                Navigator.pushNamed(context, SettingsScreen.id);
                              },
                            ))
                      ],
                    )
                  ]),
            ),
          ),
        );
      },
    );
  }
}

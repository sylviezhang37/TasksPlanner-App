import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:TasksPlanner/tasks/tasks_screen.dart';
import 'package:flutter/material.dart';
import '../models/list_service.dart';
import '../models/task_list.dart';
import '../models/user_lists.dart';
import '../utilities/constants.dart';

class HomePageMyLists extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: ListService().allLists,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          print("error in my lists");
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          List<TaskList> userLists = UserLists.fromQuerySnapshot(snapshot);

          return ListView.builder(
            itemCount: userLists.length,
            itemBuilder: (context, index) {
              return ElevatedButton(
                style: kHomePageButtonStyleLight,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TasksScreen(
                                listIndex: index,
                              )));
                },
                child: Text(
                  userLists[index].name,
                  style: kSubtitleTextStyle,
                ),
              );
            },
          );
        } else {
          return Text('No data found');
        }
      },
    );
  }
}

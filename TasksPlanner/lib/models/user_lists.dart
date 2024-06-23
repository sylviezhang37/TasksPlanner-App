import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/task_list.dart';

class UserLists {
  /*
  Calculate and return tasks completion percentage in fraction
   */
  static String completionFraction(List<TaskList> userLists) {
    if (userLists.isEmpty || userLists == null) {
      return '0';
    }

    int totalLen =
        userLists.map((taskList) => taskList.length).reduce((a, b) => a + b);
    int totalDone = userLists
        .map((taskList) => taskList.numOfDone())
        .reduce((a, b) => a + b);

    return "$totalDone / $totalLen";
  }

  /*
  Calculate and return tasks completion percentage
   */
  static double completionPercentage(List<TaskList> userLists) {
    if (userLists.isEmpty || userLists == null) {
      return 0;
    }

    double totalLen = userLists
        .map((taskList) => taskList.length)
        .reduce((a, b) => a + b)
        .toDouble();
    double totalDone = userLists
        .map((taskList) => taskList.numOfDone())
        .reduce((a, b) => a + b)
        .toDouble();

    if (totalLen == 0) return 0;

    return totalDone / totalLen;
  }

  /*
  Get a list of user's all task lists from query snapshot
   */
  static List<TaskList> getQuerySnapshot(
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    List<TaskList> userLists = [];
    if (snapshot.hasData) {
       // print('Has data in async QS}');
      for (var docSnapshot in snapshot.data!.docs) {
        // print('From async QS: ${docSnapshot.id} => ${docSnapshot.data()}');
        userLists.add(TaskList.getQuerySnapshot(querySnapshot: docSnapshot));
      }
    } else if (!snapshot.hasData) {
      print('From async QS: no data}');
    }
    return userLists;
  }
}

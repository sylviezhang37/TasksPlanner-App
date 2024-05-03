import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/task_list.dart';

class UserLists {
  static String taskDoneFraction(List<TaskList> userLists) {
    if (userLists.isEmpty || userLists == null) {
      return '0';
    }

    int totalLen =
        userLists.map((taskList) => taskList.length).reduce((a, b) => a + b);
    int totalDone = userLists
        .map((taskList) => taskList.numOfDone())
        .reduce((a, b) => a + b);

    return "$totalDone / $totalLen + ${userLists.length}";
  }

  static double taskDonePercentage(List<TaskList> userLists) {
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

  static List<TaskList> fromQuerySnapshot(
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    List<TaskList> userLists = [];
    if (snapshot.hasData) {
       print('has data in async query snapshot}');
      for (var docSnapshot in snapshot.data!.docs) {
        print(
            'pulling from async query snapshot: ${docSnapshot.id} => ${docSnapshot.data()}');
        userLists.add(TaskList.fromQuerySnapshot(querySnapshot: docSnapshot));
      }
    }

    if (!snapshot.hasData) {
      print('From async query snapshot: no data}');
    }
    return userLists;
  }
}

import 'dart:core';

import 'package:TasksPlanner/models/task_comparator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';
import 'package:collection/collection.dart';

class TaskList {
  late String _id;
  late String _name;
  late final PriorityQueue<Task> _tasks = PriorityQueue<Task>((a, b) => TaskComparator(a: a, b: b).compare());

  TaskList.getQuerySnapshot({required querySnapshot}) {
    var map = querySnapshot.data();

    _id = querySnapshot.id;
    _name = map['name'] ?? '';

    Map<String, dynamic> metaData = map['taskMetaData'] ?? {};
    metaData.forEach((name, metaData) {
      _tasks.add(Task(
        name: name,
        listId: _id,
        done: metaData['done'] ?? false,
        lastUpdated: metaData['lastUpdated'] ?? Timestamp.now(),
      ));
    });
  }

  TaskList.getDocSnapshot({required docSnapshot, required listId}) {
    var map = docSnapshot.data!;

    _id = listId;
    _name = map['name'] ?? '';

    Map<String, dynamic> metaData = map['taskMetaData'] ?? {};
    metaData.forEach((name, metaData) {
      _tasks.add(Task(
        name: name,
        listId: _id,
        done: metaData['done'] ?? false,
        lastUpdated: metaData['lastUpdated'] ?? Timestamp.now(),
      ));
    });
  }

  String get id => _id;
  String get name => _name;
  int get length => _tasks.length;
  PriorityQueue<Task> get tasks => _tasks;

  int numOfDone() {
    return _tasks.toList().where((task) => task.done).length;
  }

  void addTask(Task task) {
    _tasks.add(task);
  }

  void removeTask(Task task) async {
    tasks.remove(task);
  }
  
  String completionFraction() => '${numOfDone()} / $length';
  double completionPercentage() => numOfDone() / length;

  /*
  Transform a task map to meta data 
   */
  Map<String, Map> transformToMetaData() {
    Map<String, Map> metaData = {};
    for (Task task in _tasks.toList()) {
      print("each task ts: " + task.lastUpdated.toString());
      metaData[task.name] = {
        "done": task.done,
        "lastUpdated": task.lastUpdated
      };
    }
    return metaData;
  }
}

// class TaskComparator {
//   int compare(Task a, Task b) {
//     int doneComparison = boolComparator(a.done, b.done);
//     if (doneComparison != 0) {
//       return doneComparison;
//     } else if (a.done != true && b.done != true) {
//       return a.lastUpdated.compareTo(b.lastUpdated); // old before new
//     } else {
//       return 0;
//     }
//   }
//
//   /*
//   Comparator for boolean values, ordering false before true
//    */
//   int boolComparator(bool a, bool b) {
//     if (a == b) {return 0;}
//     if (a == true && b == false) {return 1;}
//     else {return -1;}
//   }
// }

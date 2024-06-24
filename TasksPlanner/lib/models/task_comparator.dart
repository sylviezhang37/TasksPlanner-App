import 'package:TasksPlanner/models/task.dart';

class TaskComparator {
  final Task a;
  final Task b;

  TaskComparator({required this.a, required this.b});

  /*
  Rank tasks by two criteria:
  1. uncompleted before completed
  2. old tasks before new tasks
   */
  int compare() {
    int doneComparison = boolComparator(a.done, b.done);
    if (doneComparison != 0) {
      return doneComparison;
    } else if (a.done != true && b.done != true) {
      return a.lastUpdated.compareTo(b.lastUpdated);
    } else {
      return 0;
    }
  }

  /*
  Comparator for boolean values, ordering false before true
   */
  int boolComparator(bool bool1, bool bool2) {
    if (bool1 == bool2) {return 0;}
    if (bool1 == true && bool2 == false) {return 1;}
    else {return -1;}
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String name;
  bool done;
  late String _listId;
  Timestamp lastUpdated;

  Task({required this.name, required listId, this.done = false, required this.lastUpdated}) {
    _listId = listId;
  }

  void changeDone() {
    lastUpdated = Timestamp.now();
    done = !done;
  }

  bool getDone() {
    return done;
  }  

  String get listId => _listId;
}

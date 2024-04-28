import '../models/task.dart';

class TaskList {
  late String _id;
  late String _name;
  late List<Task> _tasks = [];

  TaskList.fromQuerySnapshot({required querySnapshot}) {
    var map = querySnapshot.data();

    _id = querySnapshot.id;
    _name = map['name'] ?? '';

    Map<String, dynamic> metaData = map['taskMetaData'] ?? {};
    metaData.forEach((name, metaData) {
      bool done = metaData['done'] ?? false;
      _tasks.add(Task(
        name: name,
        listId: _id,
        done: done,
      ));
    });
  }

  TaskList.fromDocSnapshot({required docSnapshot, required listId}) {
    var map = docSnapshot.data!;

    _id = listId;
    _name = map['name'] ?? '';

    Map<String, dynamic> metaData = map['taskMetaData'] ?? {};
    metaData.forEach((name, metaData) {
      bool done = metaData['done'] ?? false;
      _tasks.add(Task(
        name: name,
        listId: _id,
        done: done,
      ));
    });
  }

  String get id => _id;
  String get name => _name;
  int get length => _tasks.length;
  List<Task> get tasks => _tasks;

  int numOfDone() {
    return _tasks.where((task) => task.done).length;
  }

  void addTask(Task task) {
    _tasks.add(task);
  }

  String taskDoneFraction() => '${numOfDone()} / $length';
  double taskDonePercentage() => numOfDone() / length;

  Map<String, Map> transformToMetaData() {
    Map<String, Map> metaData = {};
    for (Task task in _tasks) {
      metaData[task.name] = {"done": task.done};
    }
    return metaData;
  }

  void remove(Task task) {
    tasks.remove(task);
  }
}

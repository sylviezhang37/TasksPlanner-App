class Task {
  String name;
  bool done;
  late String _listId;

  Task({required this.name, required listId, this.done = false}) {
    _listId = listId;
  }

  void changeDone() {
    done = !done;
  }

  bool getDone() {
    return done;
  }  

  String get listId => _listId;
}

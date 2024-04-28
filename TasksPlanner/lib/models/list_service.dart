import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task_list.dart';

class ListService {
  final _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  void signOut() async {
    await _auth.signOut();
    print('signed out');
    // Navigator.pushReplacementNamed(context, WelcomeScreen.id);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> get allLists {
    return FirebaseFirestore.instance
        .collection('TaskData')
        .doc(currentUser!.uid)
        .collection('Lists')
        .orderBy('createdAt')
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getList(String id) {
    return FirebaseFirestore.instance
        .collection('TaskData')
        .doc(currentUser!.uid)
        .collection('Lists')
        .doc(id)
        .snapshots();
  }

  // create a new document and collection in TaskData
  void newUserList(String uid) async {
    await FirebaseFirestore.instance
        .collection('TaskData')
        .doc(currentUser!.uid)
        .collection('Lists')
        .doc()
        .set({});
  }

  void addTaskList(String name) async {
    final emptyList = {
      "name": name,
      "taskMetaData": {},
      "tasks": [],
      "createdAt": FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance
        .collection('TaskData')
        .doc(currentUser!.uid)
        .collection('Lists')
        .add(emptyList);
  }

  void updateTaskListMetadata(TaskList taskList) async {
    Map<String, Map> metaData = taskList.transformToMetaData();

    await FirebaseFirestore.instance
        .collection('TaskData')
        .doc(currentUser!.uid)
        .collection('Lists')
        .doc(taskList.id)
        .update({'taskMetaData': metaData});
  }
}

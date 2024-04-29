import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import '../models/task_list.dart';
import 'package:async/async.dart';

class ListService {
  final _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  void signOut() async {
    await _auth.signOut();
  }

  Future<void> deleteUserAccount() async {
    try {
      await FirebaseAuth.instance.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> allUsers() {
    return FirebaseFirestore.instance.collection('Users').snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> allTasks() {
    return FirebaseFirestore.instance.collection('Tasks').snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> userList(String listId) {
    return FirebaseFirestore.instance
        .collection('Tasks')
        .doc(listId)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> currentUserLists() {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc('VGIq0VzTjscQeOOHb2YJJk0crkr1')
        // .doc(currentUser!.uid)
        .snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> testData() async {
    DocumentSnapshot<Map<String, dynamic>> data = await FirebaseFirestore
        .instance
        .collection('Users')
        .doc('VGIq0VzTjscQeOOHb2YJJk0crkr1')
        .get();

    return data;
  }

  Stream<List<Stream<DocumentSnapshot<Map<String, dynamic>>>>>
      allListsDocSnapshots() {
    return currentUserLists().map((userDocument) {
      var data = userDocument.data();
      print("User document data: $data");
      if (data == null || data['lists'] == null) {
        return <String>[];
      }
      return List<String>.from(data['lists']);
    }).map((listIds) {
      print("List IDs: $listIds");
      return listIds.map((listId) => userList(listId)).toList();
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> allLists() {
    // Return a stream that listens to changes in currentUserLists()
    return currentUserLists().switchMap((userDocument) {
      var data = userDocument.data();
      List<String> listIds = data != null && data['lists'] != null
          ? List<String>.from(data['lists'])
          : [];

      if (listIds.isEmpty) {
        return const Stream<QuerySnapshot<Map<String, dynamic>>>.empty();
      }

      // Create a stream group to merge streams of QuerySnapshots from each list ID
      StreamGroup<QuerySnapshot<Map<String, dynamic>>> streamGroup =
          StreamGroup();
      for (var listId in listIds) {
        var stream = FirebaseFirestore.instance
            .collection('Tasks')
            .where(FieldPath.documentId, whereIn: listIds)
            .snapshots();
        streamGroup.add(stream);
      }

      return streamGroup.stream;
    });
  }

  // Stream<QuerySnapshot<Map<String, dynamic>>> get allListsOld {
  //   return FirebaseFirestore.instance
  //       .collection('TaskData')
  //       .doc(currentUser!.uid)
  //       .collection('Lists')
  //       .orderBy('createdAt')
  //       .snapshots();
  // }

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
        .collection('Tasks')
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

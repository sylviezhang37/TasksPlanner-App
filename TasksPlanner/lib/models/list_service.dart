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

  // methods for retrieving data

  Stream<QuerySnapshot<Map<String, dynamic>>> allUsers() {
    return FirebaseFirestore.instance.collection('Users').snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> taskList(String listId) {
    return FirebaseFirestore.instance
        .collection('Tasks')
        .doc(listId)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> userLists() {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser!.uid)
        .snapshots();
  }

  Stream<List<Stream<DocumentSnapshot<Map<String, dynamic>>>>>
      allListsDocSnapshots() {
    return userLists().map((userDocument) {
      var data = userDocument.data();
      if (data == null || data['lists'] == null) {
        return <String>[];
      }
      return List<String>.from(data['lists']);
    }).map((listIds) {
      return listIds.map((listId) => taskList(listId)).toList();
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> allLists() {
    // use switchmap to subscribe to changes in currentUsersList()
    return userLists().switchMap((userDocument) {
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
            .orderBy('createdAt')
            .snapshots();
        streamGroup.add(stream);
      }

      return streamGroup.stream;
    });
  }

  // methods for modifying user data

  void newUserList(String uid) async {
    // await FirebaseFirestore.instance.collection('Tasks').doc().set({});

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .set({'lists': []}).catchError((error) {
      print("Error updating user document with new lists array: $error");
    });
  }

  /// add new empty list to Tasks
  /// and update User's doc to reflect access to the new list
  Future<String> addTaskList(String name) async {
    final emptyList = {
      "name": name,
      "taskMetaData": {},
      "tasks": [],
      "createdAt": FieldValue.serverTimestamp(),
    };

    DocumentReference docRef =
        await FirebaseFirestore.instance.collection('Tasks').add(emptyList);

    // Using arrayUnion to add the new doc ID without duplication
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser!.uid)
        .update({
      'lists': FieldValue.arrayUnion([docRef.id])
    }).catchError((error) {
      print("Error updating user document with a new task list ID: $error");
    });

    return docRef.id;
  }

  Future<void> deleteTaskList(List<TaskList> userLists, String listID) async {
    List<String> listIDs = userLists.map((list) => list.id).toList();
    listIDs.remove(listID);
    print(listIDs);

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser!.uid)
        .update({'lists': listIDs}).catchError((error) {
      print("Error deleting list ID from user document: $error");
    });
  }

  Future<void> changeListName(TaskList taskList, String listName) async {
    await FirebaseFirestore.instance
        .collection('Tasks')
        .doc(taskList.id)
        .update({'name': listName}).catchError((error) {
      print("Error updating list name: $error");
    });
  }

  /// update task status, and add/remove task
  void updateTaskListMetadata(TaskList taskList) async {
    Map<String, Map> metaData = taskList.transformToMetaData();

    await FirebaseFirestore.instance
        .collection('Tasks')
        .doc(taskList.id)
        .update({'taskMetaData': metaData});
  }
}

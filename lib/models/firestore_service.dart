import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import '../models/task_list.dart';

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

  // Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
  //   return FirebaseFirestore.instance.collection('Users').snapshots();
  // }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getAllTaskList(String listId) {
    return FirebaseFirestore.instance
        .collection('Tasks')
        .doc(listId)
        .snapshots();
  }

  /*
  Get user's document snapshot
   */
  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserDoc() {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser!.uid)
        .snapshots();
  }

  /*
  Pull all lists user has access to, ordered by createdAt
   */
  Stream<QuerySnapshot<Map<String, dynamic>>> allLists() {
    // use flatMap to subscribe to changes in currentUsersList()
    return getUserDoc().flatMap((userDocument) {
      var data = userDocument.data();
      // print("From ListService.allList(): $data");
      List<String> listIds = data != null && data['lists'] != null
          ? List<String>.from(data['lists'])
          : [];

      // handling empty lists, FireStore 'whereIn' query cannot be empty
      if (listIds.isEmpty) {
        listIds = ["-"];
      }

      return FirebaseFirestore.instance
          .collection('Tasks')
          .where(FieldPath.documentId, whereIn: listIds)
          .orderBy('createdAt')
          .snapshots();
    }).handleError((error) {
      print("Error handling stream: $error");
      return const Stream.empty();
    });
  }

  /*
  Create an empty set to store list ids user has access to
   */
  void createNewUserList(String uid) async {
    // await FirebaseFirestore.instance.collection('Tasks').doc().set({});
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .set({'lists': []}).catchError((error) {
      print("Error updating user document with new lists array: $error");
    });
  }

  /*
  add new empty list to Tasks db, and update User's doc to reflect access to the new list
   */
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

  /*
  Delete an entire task list and update user's metadata
   */
  Future<void> deleteTaskList(List<TaskList> userLists, String listID) async {
    List<String> listIDs = userLists.map((list) => list.id).toList();
    listIDs.remove(listID);
    // print("Deleted tasks, new listIDs ${listIDs}");

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser!.uid)
        .update({'lists': listIDs}).catchError((error) {
      print("Error deleting list ID from user document: $error");
    });
  }

  /*
  Change the name of a task list and update user's meta data
   */
  Future<void> changeListName(TaskList taskList, String listName) async {
    await FirebaseFirestore.instance
        .collection('Tasks')
        .doc(taskList.id)
        .update({'name': listName}).catchError((error) {
      print("Error updating list name: $error");
    });
  }

  /*
  update task list meta in FireStore when
  a change to a task or a task list has been made
   */
  void updateTaskListMetadata(TaskList taskList) async {
    Map<String, Map> metaData = taskList.transformToMetaData();

    await FirebaseFirestore.instance
        .collection('Tasks')
        .doc(taskList.id)
        .update({'taskMetaData': metaData});
  }

  /*
  For debugging
   */
  Future<void> printUserLists() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          var lists = userDoc.get('lists');
          print("Printing from Firestore ${lists}");
        } else {
          print('Printing from Firestore: document does not exist.');
        }
      } else {
        print('Printing from Firestore: no user logged in.');
      }
    } catch (e) {
      print('Error fetching user lists from Firestore: $e');
    }
  }
}

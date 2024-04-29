import 'package:TasksPlanner/models/list_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  static const String id = 'test_page';

  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreen();
}

class _TestScreen extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream:
            ListService().allLists(), // Using the stream from your function
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: Text('No tasks found'));
          }

          return ListView(
            children: snapshot.data!.docs
                .map((DocumentSnapshot<Map<String, dynamic>> document) {
              Map<String, dynamic> data = document.data()!;
              return ListTile(
                title: Text(data['name'] ??
                    'No Title'), // Assuming 'title' is a field in your documents
                // subtitle: Text(data['taskMetaData'] ??
                //     'No Description'), // Assuming 'description' is another field
              );
            }).toList(),
          );
        },
      ),
    );
  }
}



  // return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
  //     stream: ListService().currentUserLists(),
  //     builder: (BuildContext context,
  //         AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
  //       return Text("hello");
  //     });
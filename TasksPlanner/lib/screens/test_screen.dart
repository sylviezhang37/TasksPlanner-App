import 'package:TasksPlanner/models/list_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TestScreen2 extends StatefulWidget {
  static const String id = 'test_page2';

  const TestScreen2({super.key});

  @override
  State<TestScreen2> createState() => _TestScreen2();
}

class _TestScreen2 extends State<TestScreen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Lists Screen'),
      ),
      body: StreamBuilder<List<Stream<DocumentSnapshot<Map<String, dynamic>>>>>(
        stream: ListService().allListsDocSnapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return Center(child: Text("No data available"));
          }

          List<Stream<DocumentSnapshot<Map<String, dynamic>>>> listStreams =
              snapshot.data!;

          return ListView.builder(
            itemCount: listStreams.length,
            itemBuilder: (context, index) {
              return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: listStreams[index],
                builder: (context, docSnapshot) {
                  if (docSnapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(title: Text("Loading..."));
                  }
                  if (!docSnapshot.hasData) {
                    return ListTile(title: Text("No data for this item"));
                  }
                  Map<String, dynamic> data = docSnapshot.data!.data()!;

                  return ListTile(
                    title: Text(data['name'] ?? 'Unnamed List'),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  // return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
  //     stream: ListService().currentUserLists(),
  //     builder: (BuildContext context,
  //         AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
  //       return Text("hello");
  //     });
}

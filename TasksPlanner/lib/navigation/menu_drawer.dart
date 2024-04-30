import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/list_service.dart';
import '../components/text_input_dialog.dart';
import '../models/task_list.dart';
import '../models/user_lists.dart';

class MenuDrawer extends StatelessWidget {
  final Function(int) onItemTapped;
  // final int selectedIndex;
  Function(BuildContext, String) addTaskListCallBack;

  MenuDrawer({required this.onItemTapped, required this.addTaskListCallBack});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: ListService().allLists(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong.");
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        List<TaskList> userLists = UserLists.fromQuerySnapshot(snapshot);

        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero, // Remove padding
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.12,
              ),
              Column(
                children: List.generate(userLists.length, (index) {
                  return ListTile(
                    title: Text(userLists[index].name),
                    selected: false,
                    onTap: () {
                      onItemTapped(index);
                      Navigator.pop(context);
                    },
                  );
                }),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              const Divider(
                height: 10,
                thickness: 1,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              TextButton.icon(
                onPressed: () {
                  displayTextInputDialog(
                    context,
                    addTaskListCallBack,
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Add List'),
              ),
            ],
          ),
        );
      },
    );
  }
}

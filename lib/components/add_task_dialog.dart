import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/firestore_service.dart';
import '../models/task.dart';
import '../models/task_list.dart';
import '../models/user_lists.dart';
import '../utilities/constants.dart';

// ignore: must_be_immutable
class AddTaskDialog extends StatelessWidget {
  TaskList selectedTaskList;

  AddTaskDialog({super.key, required this.selectedTaskList});

  void confirmAdd(Task task, BuildContext context) {
    if (task != null) {
      selectedTaskList.addTask(task!);
      ListService().updateTaskListMetadata(selectedTaskList);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Task? newTask;

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: ListService().allLists(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong.");
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          List<TaskList> userLists = UserLists.getQuerySnapshot(snapshot);
          List<DropdownMenuEntry> customDropdownEntries = userLists
              .map((taskList) => DropdownMenuEntry(
                    value: taskList.id,
                    label: taskList.name,
                    style: kDropDownMenuItemStyle,
                  ))
              .toList();

          void menuSelectedCallBack(String value) {
            selectedTaskList =
                userLists.where((taskList) => taskList.id == value).first;
          }

          DropdownMenu taskListMenu = DropdownMenu(
            requestFocusOnTap: true,
            enableSearch: true,
            textStyle: kBodyTextStyleDark,
            menuStyle: const MenuStyle(alignment: Alignment.centerLeft),
            initialSelection: selectedTaskList.id,
            dropdownMenuEntries: customDropdownEntries,
            onSelected: (value) {
              menuSelectedCallBack(value);
            },
            leadingIcon: Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.primary,
            ),
            width: MediaQuery.of(context).size.width * 0.7,
            inputDecorationTheme: InputDecorationTheme(
              hintStyle: kHintTextStyleDark,
              border: kOutlineBorder,
              focusedBorder: kOutlineBorder,
            ),
          );

          return Container(
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Material(
                    elevation: 3,
                    borderRadius: BorderRadius.circular(30.0),
                    child: taskListMenu,
                  ),
                ),
                kSpacing,
                kSpacing,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: TextField(
                      autofocus: true,
                      textAlign: TextAlign.center,
                      decoration: kInputDecoration(context, "To Do"),
                      onChanged: (input) {
                        newTask = Task(
                          listId: selectedTaskList.id,
                          name: input,
                          lastUpdated: Timestamp.now(),
                        );
                      },
                      onEditingComplete: () {
                        confirmAdd(newTask!, context);
                      }),
                ),
                kSpacing,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 135.0,
                      child: TextButton(
                        child: Text(
                          'CANCEL',
                          style: kdialogActionTextStyle,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 135.0,
                      child: TextButton(
                        child: Text(
                          'ADD',
                          style: kdialogActionTextStyle,
                        ),
                        onPressed: () {
                          confirmAdd(newTask!, context);
                          // if (newTask != null) {
                          //   selectedTaskList.addTask(newTask!);
                          //   ListService()
                          //       .updateTaskListMetadata(selectedTaskList);
                          // }
                          // Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}

import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final bool isChecked;
  final String taskName;
  final Function(bool?) checkBoxCallBack;
  final VoidCallback longPressDelete;

  TaskTile(
      {required this.isChecked,
      required this.taskName,
      required this.checkBoxCallBack,
      required this.longPressDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        taskName,
        style: TextStyle(
          decoration: isChecked ? TextDecoration.lineThrough : null,
          color: isChecked
              ? Colors.grey[400]
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
      trailing: Checkbox(
        value: isChecked,
        onChanged: checkBoxCallBack,
      ),
      onLongPress: longPressDelete,
    );
  }
}

import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final String text;
  final bool checked;
  final Function setChecked;

  TaskTile({
    required this.text,
    required this.checked,
    required this.setChecked,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        text,
        style: TextStyle(
          fontSize: 20.0,
          color: Colors.black,
          decoration:
              checked ? TextDecoration.lineThrough : TextDecoration.none,
        ),
      ),
      trailing: Checkbox(
        activeColor: Theme.of(context).primaryColor,
        value: checked,
        onChanged: (bool? val) {
          setChecked.call();
        },
      ),
    );
  }
}

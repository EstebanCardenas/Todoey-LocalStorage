import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:todoey/models/task.dart';
import 'package:todoey/providers/tasks_provider.dart';

import 'task_tile.dart';

class TaskList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    TasksNotifier tasksNotifier = useProvider(tasksProvider.notifier);
    Color primaryColor = Theme.of(context).primaryColor;

    Widget taskList = ListView.builder(
      itemCount: tasksNotifier.numberOfTasks,
      itemBuilder: (BuildContext context, int idx) {
        Task cTask = tasksNotifier.currentTasks[idx];
        return TextButton(
          style: TextButton.styleFrom(
            primary: Theme.of(context).primaryColor,
          ),
          child: TaskTile(
            text: cTask.task,
            checked: cTask.done,
            setChecked: () {
              tasksNotifier.toggleDone(idx);
            },
          ),
          onLongPress: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Delete Task'),
                  content: Text('Are you sure you want to delete this task?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        tasksNotifier.removeTask(idx);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Yes',
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          onPressed: () {},
        );
      },
    );

    return FutureBuilder(
      future: tasksNotifier.loadTasks(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return taskList;
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error,
                  color: Colors.red,
                ),
                SizedBox(height: 14),
                Text(
                  'Failed to load tasks',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          );
        }
      },
    );
  }
}

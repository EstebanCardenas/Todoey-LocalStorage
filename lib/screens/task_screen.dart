import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todoey/models/task.dart';
import 'package:todoey/providers/color_provider.dart';
import 'package:todoey/providers/db_provider.dart';
import 'package:todoey/providers/tasks_provider.dart';
import 'package:todoey/screens/add_task_screen.dart';
import 'package:todoey/widgets/task_list.dart';

class TaskScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    TasksNotifier tasksNotifier = useProvider(tasksProvider.notifier);
    ColorNotifier colorNotifier = useProvider(colorProvider.notifier);
    bool dbIsInit = useProvider(dbProvider).isInit;
    Map<Color, String> availableColors = useProvider(availableColorsProvider);

    Color primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      floatingActionButton: Visibility(
        visible: dbIsInit,
        child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: AddTaskScreen(
                    onAdd: (Task task) {
                      tasksNotifier.addTask(task);
                    },
                  ),
                ),
              ),
            );
          },
          child: Icon(Icons.add),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(30.0, 60.0, 30.0, 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  child: IconButton(
                    icon: Icon(
                      Icons.list,
                      color: Theme.of(context).primaryColor,
                    ),
                    iconSize: 40.0,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Settings'),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('Color:'),
                                DropdownButton(
                                  value: primaryColor,
                                  items: availableColors.keys.map((Color c) {
                                    return DropdownMenuItem(
                                      value: c,
                                      child: Text(availableColors[c]!),
                                    );
                                  }).toList(),
                                  onChanged: (Color? newColor) {
                                    primaryColor = newColor!;
                                    colorNotifier.setPrimaryColor(newColor);
                                  },
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'Close',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  backgroundColor: Colors.white,
                  radius: 30.0,
                ),
                SizedBox(
                  height: 35.0,
                ),
                Text(
                  'Todoey',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 60.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${tasksNotifier.numberOfTasks} Task${tasksNotifier.numberOfTasks == 1 ? "" : "s"}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 50.0),
              child: TaskList(),
            ),
          ),
        ],
      ),
    );
  }
}

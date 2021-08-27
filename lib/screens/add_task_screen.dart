import 'package:flutter/material.dart';
import 'package:todoey/models/task.dart';

class AddTaskScreen extends StatefulWidget {
  final Function onAdd;
  const AddTaskScreen({Key? key, required this.onAdd}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  String? _taskTxt;

  void onSubmitted() {
    if (_taskTxt != null) {
      widget.onAdd(Task(task: _taskTxt!));
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF757575),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add Task',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 40.0,
              ),
            ),
            TextField(
              autofocus: true,
              cursorColor: Theme.of(context).primaryColor,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 5.0,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 5.0,
                  ),
                ),
              ),
              onChanged: (String? val) {
                _taskTxt = val;
              },
              onSubmitted: (_) => onSubmitted(),
            ),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: onSubmitted,
              child: Text(
                'Add',
                style: TextStyle(fontSize: 20.0),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                primary: Theme.of(context).primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}

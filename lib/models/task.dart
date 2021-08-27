import 'package:flutter/cupertino.dart';

class Task {
  final int id;
  final String task;
  int intDone;

  factory Task({
    int? id,
    required String task,
    int? intDone,
  }) {
    return Task._internal(
      id: id ?? UniqueKey().hashCode,
      task: task,
      intDone: intDone ?? 0,
    );
  }

  Task._internal({
    required this.id,
    required this.task,
    required this.intDone,
  });

  get done => intDone == 1;

  void toggleDone() {
    intDone = intDone == 0 ? 1 : 0;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'task': task,
      'isDone': intDone,
    };
  }

  @override
  String toString() {
    return 'Task{id: $id, task: $task, isDone: $intDone}';
  }
}

import 'dart:collection';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todoey/models/task.dart';
import 'package:todoey/providers/db_provider.dart';

final tasksProvider = StateNotifierProvider<TasksNotifier, List<Task>>((ref) {
  DatabaseClient dbClient = ref.watch(dbProvider);
  return TasksNotifier(dbClient: dbClient);
});

class TasksNotifier extends StateNotifier<List<Task>> {
  DatabaseClient dbClient;

  TasksNotifier({required this.dbClient}) : super(<Task>[]);

  UnmodifiableListView<Task> get currentTasks => UnmodifiableListView(state);
  int get numberOfTasks => state.length;

  Future<bool> loadTasks() async {
    try {
      await dbClient.init();
      List<Task> tasks = await dbClient.getTasks();
      state = tasks;
      return true;
    } on Exception catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<void> addTask(Task nTask) async {
    await dbClient.insertTask(nTask);
    state.add(nTask);
  }

  Future<void> toggleDone(int idx) async {
    if (idx >= 0 && idx < state.length) {
      Task task = state[idx];
      task.toggleDone();
      await dbClient.updateTask(task);
      state[idx] = task;
    }
  }

  Future<void> removeTask(int idx) async {
    if (idx >= 0 && idx < state.length) {
      await dbClient.deleteTask(state[idx].id);
      state.removeAt(idx);
    }
  }
}

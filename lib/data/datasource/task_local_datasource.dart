import 'package:hive/hive.dart';
import '../models/task_model.dart';

class TaskLocalDataSource {
  static const String _boxName = 'tasksBox';

  Future<Box<TaskModel>> _openBox() async {
    return await Hive.openBox<TaskModel>(_boxName);
  }

  Future<List<TaskModel>> getTasks() async {
    final box = await _openBox();
    return box.values.toList();
  }

  Future<void> addTask(TaskModel task) async {
    final box = await _openBox();
    await box.add(task);
  }

  Future<void> updateTask(int index, TaskModel task) async {
    final box = await _openBox();
    await box.putAt(index, task);
  }

  Future<void> deleteTask(int index) async {
    final box = await _openBox();
    await box.deleteAt(index);
  }
}

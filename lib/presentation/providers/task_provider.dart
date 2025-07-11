import 'package:flutter/material.dart';

import '../../data/datasource/task_local_datasource.dart';
import '../../data/models/task_model.dart';


enum FilterType { all, active, completed }

class TaskProvider extends ChangeNotifier {
  final TaskLocalDataSource _dataSource = TaskLocalDataSource();

  List<TaskModel> _tasks = [];
  FilterType _filter = FilterType.all;

  List<TaskModel> get tasks {
    switch (_filter) {
      case FilterType.active:
        return _tasks.where((task) => !task.isCompleted).toList();
      case FilterType.completed:
        return _tasks.where((task) => task.isCompleted).toList();
      case FilterType.all:
      default:
        return _tasks;
    }
  }

  FilterType get filter => _filter;

  Future<void> loadTasks() async {
    _tasks = await _dataSource.getTasks();
    notifyListeners();
  }

  Future<void> addTask(String title) async {
    final newTask = TaskModel(title: title);
    await _dataSource.addTask(newTask);
    await loadTasks();
  }

  Future<void> toggleComplete(int index) async {
    final task = tasks[index];
    task.isCompleted = !task.isCompleted;
    await _dataSource.updateTask(index, task);
    await loadTasks();
  }

  Future<void> deleteTask(int index) async {
    await _dataSource.deleteTask(index);
    await loadTasks();
  }

  void setFilter(FilterType filter) {
    _filter = filter;
    notifyListeners();
  }
}

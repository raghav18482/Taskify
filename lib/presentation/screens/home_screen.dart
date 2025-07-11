import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final provider = Provider.of<TaskProvider>(context, listen: false);
    await provider.loadTasks();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Taskify'),
        actions: [
          PopupMenuButton<FilterType>(
            onSelected: provider.setFilter,
            itemBuilder: (_) => const [
              PopupMenuItem(
                  value: FilterType.all, child: Text('All')),
              PopupMenuItem(
                  value: FilterType.active, child: Text('Active')),
              PopupMenuItem(
                  value: FilterType.completed, child: Text('Completed')),
            ],
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: provider.tasks.length,
        itemBuilder: (_, index) {
          final task = provider.tasks[index];
          return ListTile(
            title: Text(
              task.title,
              style: TextStyle(
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
            leading: Checkbox(
              value: task.isCompleted,
              onChanged: (_) => provider.toggleComplete(index),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => provider.deleteTask(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Task'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Task Title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final title = controller.text.trim();
              if (title.isNotEmpty) {
                Provider.of<TaskProvider>(context, listen: false)
                    .addTask(title);
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'data/models/task_model.dart';
import 'presentation/providers/task_provider.dart';
import 'presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  runApp(const TaskifyApp());
}

class TaskifyApp extends StatelessWidget {
  const TaskifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskProvider(),
      child: MaterialApp(
        title: 'Taskify',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

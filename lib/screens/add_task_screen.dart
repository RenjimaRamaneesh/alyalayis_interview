import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/task.dart';
import '../provider/task_provider.dart';


class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  String title = '';
  String description = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Task Title'),
              onChanged: (value) {
                title = value;
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Task Description'),
              onChanged: (value) {
                description = value;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (title.isNotEmpty && description.isNotEmpty) {

                  final task = Task(
                    title: title,
                    description: description,
                    date: DateTime.now(),
                  );
                  context.read<TaskProvider>().addTask(task);

                  Navigator.pop(context);
                } else {

                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Please fill in both fields'),
                  ));
                }
              },
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}

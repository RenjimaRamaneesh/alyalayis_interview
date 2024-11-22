import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../model/task.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/*class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;
  Future<void> loadTasks() async {
    final Database db = await openDatabase(
      join(await getDatabasesPath(), 'tasks.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, date TEXT)",
        );
      },
      version: 1,
    );
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    _tasks = List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    final Database db = await openDatabase(
      join(await getDatabasesPath(), 'tasks.db'),
    );
    await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    loadTasks();
  }

  List<Task> getTasksForDay(DateTime day) {
    return _tasks.where((task) {
      return task.date.year == day.year &&
          task.date.month == day.month &&
          task.date.day == day.day;}).toList();
  }
}*/


class TaskProvider with ChangeNotifier {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  // Initialize notifications
  Future<void> initializeNotifications() async {
    final AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Load tasks from SQLite database
  Future<void> loadTasks() async {
    final Database db = await openDatabase(
      join(await getDatabasesPath(), 'tasks.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, date TEXT)",
        );
      },
      version: 1,
    );
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    _tasks = List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
    notifyListeners();
  }

  // Add a task to the SQLite database and show notification
  Future<void> addTask(Task task) async {
    final Database db = await openDatabase(
      join(await getDatabasesPath(), 'tasks.db'),
    );
    await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    loadTasks();

    // Schedule notification for this task
    showTaskReminderNotification(task);
  }

  // Show task reminder notification
  Future<void> showTaskReminderNotification(Task task) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'task_channel',
      'Task Reminders',
      channelDescription: 'Task reminders for your to-do app',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Task Reminder: ${task.title}',
      task.description,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  // Get tasks for a specific day
  List<Task> getTasksForDay(DateTime day) {
    return _tasks.where((task) {
      return task.date.year == day.year &&
          task.date.month == day.month &&
          task.date.day == day.day;
    }).toList();
  }
}


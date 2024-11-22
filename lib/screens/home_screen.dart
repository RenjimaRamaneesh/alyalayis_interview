import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../provider/task_provider.dart';
import 'add_task_screen.dart';
import 'chat_screen.dart';






class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDay = DateTime.now(); // Track the selected date
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final tasksForSelectedDay =
    context.watch<TaskProvider>().getTasksForDay(_selectedDay);

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: (day) {
              return context.watch<TaskProvider>().getTasksForDay(day);
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasksForSelectedDay.length,
              itemBuilder: (context, index) {
                final task = tasksForSelectedDay[index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description),
                  onTap: () {},
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ChatScreen()),
              );
            },
            child: const Icon(Icons.chat),
          ),
          const SizedBox(width: 20),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTaskScreen()),
              );
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}







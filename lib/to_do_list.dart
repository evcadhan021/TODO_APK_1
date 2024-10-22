import 'package:flutter/material.dart';
import 'add_task_screen.dart';
import './model/task.dart';

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ToDoListPageState createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  List<Task> tasks = [];

  void addOrEditTask(String title, int? index) {
    setState(() {
      if (index == null) {
        tasks.add(Task(title: title, isDone: true, id: 1));
      } else {
        tasks[index].title = title; // Update title task yang dipilih
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do-List'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(tasks[index].title),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: tasks[index].isDone,
                  onChanged: (bool? value) {
                    setState(() {
                      tasks[index].isDone = value!;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      tasks.removeAt(index); // Hapus task dari list
                    });
                  },
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddTaskScreen(
                    onAddTask: addOrEditTask,
                    task: tasks[index], // Kirim task untuk diedit
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(onAddTask: addOrEditTask),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

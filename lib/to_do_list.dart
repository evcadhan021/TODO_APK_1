import 'package:flutter/material.dart';
import 'task.dart'; // Import Task model
import 'task_manager.dart'; // Import TaskManager for SharedPreferences

class ToDoListPage extends StatefulWidget {
  @override
  _ToDoListPageState createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  List<Task> _tasks = [];
  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks(); // Load tasks saat pertama kali app dibuka
  }

  // Fungsi untuk simpan task ke SharedPreferences
  void _saveTasks() async {
    await TaskManager.saveTasks(_tasks);
  }

  // Fungsi untuk load task dari SharedPreferences
  void _loadTasks() async {
    List<Task> loadedTasks = await TaskManager.loadTasks();
    setState(() {
      _tasks = loadedTasks;
    });
  }

  // Fungsi untuk menambahkan task baru
  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        _tasks.add(Task(
          id: DateTime.now()
              .millisecondsSinceEpoch, // ID unik sebagai int berdasarkan waktu

          title: _taskController.text, // Judul task dari inputan user
          isDone: false, // Default task baru belum selesai (false)
        ));
        _taskController.clear(); // Hapus teks di form
      });
      _saveTasks(); // Simpan task setelah menambahkan
    }
  }

  // Fungsi untuk mengedit task
  void _editTask(int index) {
    TextEditingController editController =
        TextEditingController(text: _tasks[index].title);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: TextField(
            controller: editController,
            decoration: InputDecoration(labelText: 'Task Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _tasks[index].title = editController.text;
                });
                _saveTasks(); // Simpan task setelah diedit
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To Do List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: InputDecoration(labelText: 'Enter Task'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addTask, // Tambah task baru saat tombol ditekan
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return ListTile(
                  title: Text(task.title),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: task.isDone,
                        onChanged: (value) {
                          setState(() {
                            task.isDone = value ?? false;
                          });
                          _saveTasks(); // Simpan task saat status berubah
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editTask(index), // Panggil edit task
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

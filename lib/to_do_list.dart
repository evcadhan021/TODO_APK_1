import 'package:flutter/material.dart';
import 'task.dart'; // Import Task model
import 'task_manager.dart'; // Import TaskManager for SharedPreferences

class ToDoListPage extends StatefulWidget {
  @override
  _ToDoListPageState createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  List<Task> _tasks = [];
  String _filter = 'All'; // Default filter adalah 'All'
  final TextEditingController _taskController = TextEditingController();

  // Controll untuk pencarian keyword task
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Fungsi untuk task berdasarkan pencarian
  List<Task> _getSearchResults() {
    if (_searchQuery.isEmpty) {
      return _getFilteredTasks(); // Tampilkan task sesuai filter status kalau gak ada pencarian
    } else {
      return _getFilteredTasks().where((task) {
        return task.title.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
  }

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
          createdDate: DateTime.now().microsecondsSinceEpoch,
        ));
        _taskController.clear(); // Hapus teks di form
      });
      _saveTasks(); // Simpan task setelah menambahkan
    }
  }

  // Fungsi untuk men-sorting berdasarkan Status
  void _sortByStatus() {
    setState(() {
      _tasks.sort((a, b) {
        if (a.isDone && !b.isDone) {
          return 1; // Task yang sudah selesai di bawah
        } else if (!a.isDone && b.isDone) {
          return -1; // Task yang belum selesai di atas
        } else {
          return 0; // Tetap di posisi yang sama
        }
      });
    });
  }

  // Fungsi untuk men-sorting berdasarkan Tanggal
  void _sortByDate() {
    setState(() {
      _tasks.sort((a, b) => a.createdDate.compareTo(b.createdDate));
    });
  }

  // Fungsi untuk men-sorting berdasarkan Abjad
  void _sortByTitle() {
    setState(() {
      _tasks.sort((a, b) => a.title.compareTo(b.title));
    });
  }

  // Fungsi untuk mengedit task // disini ada ShowDialog
  void _editTask(int index) {
    TextEditingController editController =
        TextEditingController(text: _tasks[index].title);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(labelText: 'Task Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _tasks[index].title = editController.text;
                });
                _saveTasks(); // Simpan task setelah diedit
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // fungsi untuk menghapus task (tugas)
  void _deleteTask(int index) {
    // Simpan task yang dihapus sementara
    Task deletedTask = _tasks[index];
    int deletedIndex = index;

    // Hapus task dari list
    setState(() {
      _tasks.removeAt(index); // Hapus task dari list
    });

    _saveTasks(); // Simpan setelah task dihapus

    // Munculkan snackbar dengan opsi undo
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task "${deletedTask.title}" deleted'),
        action: SnackBarAction(
          label: 'undo',
          onPressed: () {
            // Tambahkan task yang dihapus kembali ke list
            setState(() {
              _tasks.insert(deletedIndex, deletedTask);
            });
            _saveTasks(); // Simpan task setelah undo
          },
        ),
      ),
    );
  }

  // Fungsi untuk filter task
  List<Task> _getFilteredTasks() {
    if (_filter == 'Completed') {
      return _tasks.where((task) => task.isDone).toList();
    } else if (_filter == 'Incomplete') {
      return _tasks.where((task) => !task.isDone).toList();
    }
    return _tasks; // Default : Tampilkan semua task
  }

  // Fungsi untuk mark semua task sebagai selesai
  void _markAllAsCompleted() {
    setState(() {
      for (var task in _tasks) {
        task.isDone = true; // Tandai semua task sebagai selesai
      }
    });
    _saveTasks();
  }

  // Fungsi untuk mark semua task sebagai belum selesai
  void _markAllAsIncomplete() {
    setState(() {
      for (var task in _tasks) {
        task.isDone = false; // tandai semua mark sebagai belum selesai
      }
    });
    _saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    List<Task> filteredTasks =
        _getFilteredTasks(); // Ambil task yang sudah difilter
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        actions: [
          IconButton(
            onPressed:
                _markAllAsCompleted, // Fungsi untuk mark semua task selesai
            icon: const Icon(Icons.done_all),
            tooltip: 'Mark All as Completed',
          ),
          IconButton(
            onPressed:
                _markAllAsIncomplete, // Fungsi untuk mark semua task belum selesai
            icon: const Icon(Icons.undo),
            tooltip: 'Mark All as Incompleted',
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'status') {
                _sortByStatus();
              } else if (value == 'date') {
                _sortByDate();
              } else if (value == 'title') {
                _sortByTitle();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'status',
                  child: Text('Sort by Status'),
                ),
                const PopupMenuItem(
                  value: 'date',
                  child: Text('Sort by Date'),
                ),
                const PopupMenuItem(
                  value: 'title',
                  child: Text('Sort by Title'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Seacrh Task',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _getSearchResults().length,
              itemBuilder: (context, index) {
                final task = _getSearchResults()[index];
                return ListTile(
                  title: Text(task.title),
                  // lanjutkan dengan kode task yang ada
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(labelText: 'Enter Task'),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.add_comment_rounded,
                    size: 40,
                  ),
                  onPressed: _addTask, // Tambah task baru saat tombol ditekan
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('filter:'),
                DropdownButton<String>(
                  value: _filter,
                  items: const [
                    DropdownMenuItem(
                      value: 'All',
                      child: Text('All'),
                    ),
                    DropdownMenuItem(
                      value: 'Completed',
                      child: Text('Completed'),
                    ),
                    DropdownMenuItem(
                      value: 'Incomplete',
                      child: Text('Incomplete'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _filter = value!; // Update Filter Sesuai Pilihan
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                if (index >= filteredTasks.length) {
                  return const SizedBox
                      .shrink(); // Mencegah akses index di luar range
                }
                final task = filteredTasks[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0), // Tambahin jarak vertikal
                  child: ListTile(
                    textColor: Colors.green,
                    tileColor: Colors.black,
                    title: Text(
                      task.title,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
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
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                          onPressed: () =>
                              _editTask(index), // Panggil edit task
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () =>
                              _deleteTask(index), // Panggil delete task
                        ),
                      ],
                    ),
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

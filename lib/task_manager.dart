import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'task.dart'; // Import model Task

class TaskManager {
  static Future<void> saveTasks(List<Task> tasks) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskList =
        tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList('tasks', taskList);
  }

  static Future<List<Task>> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? taskList = prefs.getStringList('tasks');
    if (taskList != null) {
      return taskList.map((task) => Task.fromJson(jsonDecode(task))).toList();
    }
    return [];
  }
}

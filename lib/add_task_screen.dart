import 'package:flutter/material.dart';
import 'task.dart';

class AddTaskScreen extends StatelessWidget {
  final Function(String, int?) onAddTask; // Parameter untuk edit
  final TextEditingController taskController = TextEditingController();
  final Task? task; // Menyimpan task jika sedang diedit

  AddTaskScreen({required this.onAddTask, this.task}) {
    if (task != null) {
      taskController.text = task!.title; // Set text field dengan title task
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task == null ? 'Add New Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: taskController,
              decoration: const InputDecoration(
                labelText: 'Task Name',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                onAddTask(
                    taskController.text, task?.id); // Kirim id task untuk edit
                Navigator.pop(context);
              },
              child: Text(task == null ? 'Add Task' : 'Update Task'),
            ),
          ],
        ),
      ),
    );
  }
}

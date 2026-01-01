import 'package:flutter/material.dart';

class GPTasks extends StatefulWidget {
  const GPTasks({super.key});

  @override
  State<GPTasks> createState() => _GPTasksState();
}

class _GPTasksState extends State<GPTasks> {
  final TextEditingController taskController = TextEditingController();
  List<Map<String, dynamic>> tasks = [];

  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
  }

  void _addTask() {
    final text = taskController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      tasks.add({'name': text, 'done': false});
      taskController.clear();
    });
  }

  void _toggleTask(int index, bool? value) {
    setState(() {
      tasks[index]['done'] = value ?? false;
    });
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          // Input field + Add button
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: taskController,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  onSubmitted: (_) => _addTask(),
                  decoration: InputDecoration(
                    hintText: 'New task...',
                    hintStyle: TextStyle(
                      color: isDark ? Colors.grey[500] : Colors.grey[500],
                    ),
                    filled: true,
                    fillColor: isDark
                        ? const Color(0xFF475569)
                        : const Color(0xFFF9FAFB),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xff3B82F6),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xff3B82F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: _addTask,
                  icon: const Icon(Icons.add, color: Colors.white),
                  tooltip: 'Add task',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Task list
          Expanded(
            child: tasks.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 64,
                    color: isDark ? Colors.grey[700] : Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tasks yet',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? Colors.grey[400]
                          : const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add your first task to get started',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.grey[500] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Dismissible(
                  key: Key('${task['name']}_$index'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFef4444),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (_) => _deleteTask(index),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF475569)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? Colors.grey[700]!
                            : Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      title: Text(
                        task['name'],
                        style: TextStyle(
                          decoration: task['done']
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: task['done']
                              ? (isDark ? Colors.grey[600] : Colors.grey)
                              : (isDark
                              ? Colors.white
                              : const Color(0xFF0F172A)),
                          fontSize: 15,
                        ),
                      ),
                      secondary: IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: isDark
                              ? Colors.grey[500]
                              : Colors.grey[600],
                          size: 20,
                        ),
                        onPressed: () => _deleteTask(index),
                        tooltip: 'Delete task',
                      ),
                      value: task['done'],
                      onChanged: (val) => _toggleTask(index, val),
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
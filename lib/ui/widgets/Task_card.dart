import 'package:flutter/material.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({super.key});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Title of the task",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
            Text("Description of the task"),
            Text("Date:12/12/2002"),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTaskStatusChip(),
                Wrap(
                  children: [
                    IconButton(
                      onPressed: _onTapEdit,
                      icon: Icon(Icons.edit, size: 20, color: Colors.blue),
                    ),
                    IconButton(
                      onPressed: _onTapDelete,
                      icon: Icon(Icons.delete, size: 20, color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onTapEdit() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['New', 'Completed', 'Cancelled', 'Progress'].map((e) {
              return ListTile(onTap: () {}, title: Text(e));
            }).toList(),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancle'),
            ),
            TextButton(onPressed: () {}, child: const Text('Okay')),
          ],
        );
      },
    );
  }

  void _onTapDelete() {
    // Handle delete action
  }

  Widget _buildTaskStatusChip() {
    return Chip(label: Text("New", style: TextStyle(fontSize: 10)));
  }
}

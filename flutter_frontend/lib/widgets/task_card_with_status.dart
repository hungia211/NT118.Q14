import 'package:flutter/material.dart';
import '../../models/task.dart';
import 'task_card.dart';

class TaskCardWithStatus extends StatelessWidget {
  final Task task;

  const TaskCardWithStatus({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    Color borderColor;
    IconData icon;

    switch (task.status) {
      case 'done':
        borderColor = Colors.green;
        icon = Icons.check;
        break;
      case 'in-progress':
        borderColor = Colors.orange;
        icon = Icons.access_time;
        break;
      case 'failed':
        borderColor = Colors.red;
        icon = Icons.close;
        break;
      default:
        borderColor = Colors.blue;
        icon = Icons.radio_button_unchecked;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: TaskCard(task: task),
        ),

        Positioned(
          right: 12,
          top: 60,
          child: Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: borderColor, width: 2),
            ),
            child: Icon(icon, color: borderColor),
          ),
        ),
      ],
    );
  }
}

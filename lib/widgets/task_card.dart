import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  Color get bgColor {
    switch (task.status) {
      case 'done':
        return const Color(0xFF4CAF50);
      case 'in-progress':
        return const Color(0xFFFFC107);
      case 'failed':
        return const Color(0xFFE57373);
      default:
        return const Color(0xFF90CAF9);
    }
  }

  String get timeLabel {
    final start = DateFormat('h:mm a').format(task.startTime);
    final mins = task.duration.inMinutes;
    final h = mins ~/ 60;
    final m = mins % 60;

    return "$start • ${h > 0 ? '$h h ' : ''}${m > 0 ? '$m m' : ''}";
  }


  // MAP CATEGORY → ILLUSTRATION
  String get illustration {
    switch (task.category) {
      case 'work':
        return 'assets/illus/meeting.png';
      case 'study':
        return 'assets/illus/coding.png';
      case 'relax':
        return 'assets/illus/relax.png';
      case 'health':
        return 'assets/illus/workout.png';
      case 'gardening':
        return 'assets/illus/plant.png';
      case 'cook':
        return 'assets/illus/cook.png';
      case 'meditation':
        return 'assets/illus/meditation.png';
      case 'other':
        return 'assets/illus/default.png';
      default:
        return 'assets/illus/default.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      padding: const EdgeInsets.fromLTRB(24, 20, 20, 20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          // ================= LEFT TEXT =================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  timeLabel,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (task.description != null)
                  Text(
                    task.description!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70),
                  ),
              ],
            ),
          ),

          // ================= RIGHT IMAGE =================
          Image.asset(illustration, height: 90, fit: BoxFit.contain),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/task_draft.dart';

class TaskCardPreview extends StatelessWidget {
  final TaskDraft task;

  const TaskCardPreview({super.key, required this.task});

  // ================= DEFAULT COLOR (AI → NOT STARTED) =================
  Color get bgColor => const Color(0xFF90CAF9);

  // ================= TIME LABEL =================
  String get timeLabel {
    final start = DateFormat('h:mm a').format(task.startTime);
    final mins = task.durationMinutes;
    final h = mins ~/ 60;
    final m = mins % 60;

    return "$start • ${h > 0 ? '$h h ' : ''}${m > 0 ? '$m m' : ''}";
  }

  // ================= ILLUSTRATION =================
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
      default:
        return 'assets/illus/default.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      height: 130,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Container(
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
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    task.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),

            // ================= RIGHT IMAGE =================
            Image.asset(
              illustration,
              height: 90,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}

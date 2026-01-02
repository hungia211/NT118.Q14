import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pomodoro_controller.dart';

class PomodoroBubble extends StatefulWidget {
  final VoidCallback onTap;
  final VoidCallback onClose;
  final ValueChanged<Offset> onDrag;

  const PomodoroBubble({
    super.key,
    required this.onTap,
    required this.onClose,
    required this.onDrag,
  });

  @override
  State<PomodoroBubble> createState() => _PomodoroBubbleState();
}

class _PomodoroBubbleState extends State<PomodoroBubble> {
  final controller = Get.find<PomodoroController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onPanUpdate: (details) {
        widget.onDrag(details.delta); // sẽ truyền từ overlay
      },
      onTap: widget.onTap,
      child: Material(
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Obx(() => Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.redAccent,
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 8),
                ],
              ),
              child: Center(
                child: Text(
                  controller.timeText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                widget.onClose();
              },
              child: Container(
                width: 18,
                height: 18,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black54,
                ),
                child: const Icon(
                  Icons.close,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

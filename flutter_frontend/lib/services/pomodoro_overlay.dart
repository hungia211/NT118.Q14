import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/pomodoro_bubble.dart';

class PomodoroOverlay {
  static OverlayEntry? _entry;
  static Offset _position = const Offset(20, 120);

  static void show({
    required VoidCallback onTap,
    required VoidCallback onClose,
  }) {
    hide(); // đảm bảo không có overlay treo

    _entry = OverlayEntry(
      builder: (_) {
        return Stack(
          children: [
            Positioned(
              left: _position.dx,
              top: _position.dy,
              child: PomodoroBubble(
                onTap: onTap,
                onClose: onClose,
                onDrag: (delta) {
                  _position += delta;
                  _entry?.markNeedsBuild();
                },
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(Get.overlayContext!).insert(_entry!);
  }

  static void hide() {
    _entry?.remove();
    _entry = null;
  }
}

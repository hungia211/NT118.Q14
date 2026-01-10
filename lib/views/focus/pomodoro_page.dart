import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/pomodoro_controller.dart';
import '../../services/pomodoro_overlay.dart';

class PomodoroPage extends StatelessWidget {
  PomodoroPage({super.key});

  final PomodoroController controller = Get.find<PomodoroController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FEFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () {
            Get.back();

            PomodoroOverlay.show(
              onTap: () {
                Get.to(() => PomodoroPage());
                PomodoroOverlay.hide();
              },
              onClose: () {
                controller.stop();
                PomodoroOverlay.hide();
              },
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Tập trung",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 40),

            // TIME
            Obx(() {
              if (controller.status.value == PomodoroStatus.finished) {
                return const Text(
                  "Hoàn thành 🎉",
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }

              return Text(
                controller.timeText,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                ),
              );
            }),


            const SizedBox(height: 40),

            // CONTROLS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // PLAY / PAUSE / RESTART
                IconButton(
                  iconSize: 64,
                  icon: Obx(() {
                    final status = controller.status.value;

                    return Icon(
                      status == PomodoroStatus.running
                          ? Icons.pause_circle
                          : status == PomodoroStatus.finished
                          ? Icons.replay_circle_filled
                          : Icons.play_circle,
                      color: Colors.black,
                    );
                  }),
                  onPressed: () {
                    final status = controller.status.value;

                    if (status == PomodoroStatus.running) {
                      controller.pause();
                    } else if (status == PomodoroStatus.paused) {
                      controller.resume();
                    } else if (status == PomodoroStatus.finished) {
                      controller.stop();   // reset
                      controller.start();  // start vòng mới
                    } else {
                      controller.start();
                    }
                  },
                ),


                // STOP (chỉ hiện khi cần)
                Obx(() {
                  final status = controller.status.value;
                  if (status == PomodoroStatus.running ||
                      status == PomodoroStatus.paused) {
                    return IconButton(
                      iconSize: 56,
                      icon: const Icon(
                        Icons.stop_circle,
                        color: Colors.redAccent,
                      ),
                      onPressed: controller.stop,
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),

          ],
        ),
      ),
    );
  }
}

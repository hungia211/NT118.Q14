import 'dart:async';
import 'package:get/get.dart';

enum PomodoroStatus { idle, running, paused, finished }

class PomodoroController extends GetxController {
  static const int workSeconds = 25 * 60;

  RxInt remainingSeconds = workSeconds.obs;
  Rx<PomodoroStatus> status = PomodoroStatus.idle.obs;

  Timer? _timer;

  bool get isRunning => status.value == PomodoroStatus.running;

  void start() {
    if (status.value == PomodoroStatus.running) return;

    status.value = PomodoroStatus.running;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        _finish();
      }
    });
  }

  void pause() {
    if (status.value != PomodoroStatus.running) return;

    _timer?.cancel();
    status.value = PomodoroStatus.paused;
  }

  void resume() {
    if (status.value != PomodoroStatus.paused) return;
    start();
  }

  void stop() {
    _timer?.cancel();
    remainingSeconds.value = workSeconds;
    status.value = PomodoroStatus.idle;
  }

  void _finish() {
    _timer?.cancel();
    status.value = PomodoroStatus.finished;
  }

  String get timeText {
    final m = remainingSeconds.value ~/ 60;
    final s = remainingSeconds.value % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}

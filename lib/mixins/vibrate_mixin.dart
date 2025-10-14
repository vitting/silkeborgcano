import 'package:vibration/vibration.dart';

mixin VibrateMixin {
  void vibrateShort() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 100);
    }
  }

  void vibrateMedium() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 110);
    }
  }

  void vibrateLong() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 120);
    }
  }
}

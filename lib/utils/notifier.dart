import 'package:vibration/vibration.dart';
import 'dart:io' show Platform;

class Notifier {
  
  static void notify() async {
    if (Platform.isAndroid || Platform.isIOS) {
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate();
      }
    } else {
      print("Notify method not implemented for this platform.");
    }
  }
  
}

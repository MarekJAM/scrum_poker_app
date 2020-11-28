import 'package:universal_platform/universal_platform.dart';
import 'package:vibration/vibration.dart';

class Notifier {
  
  static void notify() async {
    if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate();
      }
    } else {
      print("Notify method not implemented for this platform.");
    }
  }
  
}

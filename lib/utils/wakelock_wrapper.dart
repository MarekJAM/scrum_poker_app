import 'package:universal_platform/universal_platform.dart';
import 'package:wakelock/wakelock.dart';

class WakelockWrapper {
  static void enable() {
    if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
      Wakelock.enable();
    }
  }

  static void disable() {
    if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
      Wakelock.disable();
    }
  }
}

import '../../utils/storage/windows_storage_wrapper.dart';

import 'mobile_storage_wrapper.dart';
import 'storage_wrapper.dart';
import 'dart:io';

StorageWrapper getStorageWrapper() {
  if (Platform.isAndroid || Platform.isIOS) {
    return MobileStorageWrapper();
  } else if (Platform.isWindows) {
    return WindowsStorageWrapper();
  } else {
    return MobileStorageWrapper();
  }
}

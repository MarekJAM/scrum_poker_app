import 'dart:io';

import '../../utils/storage/linux_storage_wrapper.dart';
import '../../utils/storage/windows_storage_wrapper.dart';
import 'mobile_storage_wrapper.dart';
import 'storage_wrapper.dart';


StorageWrapper getStorageWrapper() {
  if (Platform.isAndroid || Platform.isIOS) {
    return MobileStorageWrapper();
  } else if (Platform.isWindows) {
    return WindowsStorageWrapper();
  } else {
    return LinuxStorageWrapper();
  }
}

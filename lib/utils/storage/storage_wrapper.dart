import 'storage_wrapper_stub.dart'
    if (dart.library.io) 'mobile_storage_wrapper.dart'
    if (dart.library.html) 'web_storage_wrapper.dart';

abstract class StorageWrapper {
  factory StorageWrapper() => getStorageWrapper();

  Future<String> readUsername();

  Future<void> writeUsername(String value);

  Future<void> deleteUsername();

  Future<String> readServerAddress();

  Future<void> writeServerAddress(String value);

  Future<void> deleteServerAddress();

  Future<String> readToken();

  Future writeToken(String value);

  Future deleteToken();
}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'storage_wrapper.dart';

class MobileStorageWrapper implements StorageWrapper {
  MobileStorageWrapper._(this.storage);

  final FlutterSecureStorage storage;

  static final MobileStorageWrapper _instance = MobileStorageWrapper._(FlutterSecureStorage());

  factory MobileStorageWrapper() => _instance;

  final String _usernameKey = 'username';
  final String _serverAddressKey = 'serverAdress';
  final String _token = 'token';

  @override
  Future<String> readUsername() async => await storage.read(key: _usernameKey);

  @override
  Future writeUsername(value) async => await storage.write(key: _usernameKey, value: value);
  
  @override
  Future deleteUsername() async => await storage.delete(key: _usernameKey);

  @override
  Future<String> readServerAddress() async => await storage.read(key: _serverAddressKey);

  @override
  Future writeServerAddress(value) async => await storage.write(key: _serverAddressKey, value: value);
  
  @override
  Future deleteServerAddress() async => await storage.delete(key: _serverAddressKey);

  @override
  Future<String> readToken() async => await storage.read(key: _token);

  @override
  Future writeToken(value) async => await storage.write(key: _token, value: value);
  
  @override
  Future deleteToken() async => await storage.delete(key: _token);
}

StorageWrapper getStorageWrapper() => MobileStorageWrapper();

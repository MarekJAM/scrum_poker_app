import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'storage_wrapper.dart';

class MobileStorageWrapper implements StorageWrapper {
  FlutterSecureStorage _storage;

  MobileStorageWrapper() {
    _storage = FlutterSecureStorage();
  }

  final String _usernameKey = 'username';
  final String _serverAddressKey = 'serverAdress';
  final String _token = 'token';

  @override
  Future<String> readUsername() async => await _storage.read(key: _usernameKey);

  @override
  Future<void> writeUsername(value) async => await _storage.write(key: _usernameKey, value: value);
  
  @override
  Future<void> deleteUsername() async => await _storage.delete(key: _usernameKey);

  @override
  Future<String> readServerAddress() async => await _storage.read(key: _serverAddressKey);

  @override
  Future<void> writeServerAddress(value) async => await _storage.write(key: _serverAddressKey, value: value);
  
  @override
  Future<void> deleteServerAddress() async => await _storage.delete(key: _serverAddressKey);

  @override
  Future<String> readToken() async => await _storage.read(key: _token);

  @override
  Future<void> writeToken(value) async => await _storage.write(key: _token, value: value);
  
  @override
  Future<void> deleteToken() async => await _storage.delete(key: _token);
}

StorageWrapper getStorageWrapper() => MobileStorageWrapper();

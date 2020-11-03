import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  SecureStorage._(this.storage);

  final FlutterSecureStorage storage;

  static final SecureStorage _instance = SecureStorage._(FlutterSecureStorage());

  factory SecureStorage() => _instance;

  final String _usernameKey = 'username';
  final String _serverAddressKey = 'serverAdress';
  final String _token = 'token';

  Future<String> readUsername() async => await storage.read(key: _usernameKey);

  Future writeUsername(value) async => await storage.write(key: _usernameKey, value: value);
  
  Future deleteUsername() async => await storage.delete(key: _usernameKey);

  Future<String> readServerAddress() async => await storage.read(key: _serverAddressKey);

  Future writeServerAddress(value) async => await storage.write(key: _serverAddressKey, value: value);
  
  Future deleteServerAddress() async => await storage.delete(key: _serverAddressKey);

  Future<String> readToken() async => await storage.read(key: _token);

  Future writeToken(value) async => await storage.write(key: _token, value: value);
  
  Future deleteToken() async => await storage.delete(key: _token);
}
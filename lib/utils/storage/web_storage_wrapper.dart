// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'package:shared_preferences/shared_preferences.dart';

import 'storage_wrapper.dart';

Window windowLoc;

class WebStorageWrapper implements StorageWrapper {

  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  final String _usernameKey = 'username';
  final String _serverAddressKey = 'serverAdress';
  final String _token = 'token';

  @override
  Future<String> readUsername() async => (await prefs).getString(_usernameKey);

  @override
  Future<void> writeUsername(value) async => (await prefs).setString(_usernameKey, value);
  
  @override
  Future<void> deleteUsername() async => (await prefs).remove(_usernameKey);

  @override
  Future<String> readServerAddress() async => (await prefs).getString(_serverAddressKey);

  @override
  Future<void> writeServerAddress(value) async => (await prefs).setString(_serverAddressKey, value);
  
  @override
  Future<void> deleteServerAddress() async => (await prefs).remove(_serverAddressKey);

  @override
  Future<String> readToken() async => (await prefs).getString(_token);

  @override
  Future<void> writeToken(value) async => (await prefs).setString(_token, value);
  
  @override
  Future<void> deleteToken() async => (await prefs).remove(_token);
}

StorageWrapper getStorageWrapper() => WebStorageWrapper();

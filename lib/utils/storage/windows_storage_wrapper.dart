import 'package:shared_preferences_windows/shared_preferences_windows.dart';

import 'storage_wrapper.dart';

class WindowsStorageWrapper implements StorageWrapper {

  SharedPreferencesWindows get prefs => SharedPreferencesWindows.instance;

  final String _usernameKey = 'username';
  final String _serverAddressKey = 'serverAdress';
  final String _token = 'token';

  @override
  Future<String> readUsername() async => (await prefs.getAll())[_usernameKey];

  @override
  Future<void> writeUsername(value) async => await prefs.setValue('String', _usernameKey, value);
  
  @override
  Future<void> deleteUsername() async => await prefs.remove(_usernameKey);

  @override
  Future<String> readServerAddress() async => (await prefs.getAll())[_serverAddressKey];

  @override
  Future<void> writeServerAddress(value) async => await prefs.setValue('String', _serverAddressKey, value);
  
  @override
  Future<void> deleteServerAddress() async => await prefs.remove(_serverAddressKey);

  @override
  Future<String> readToken() async => (await prefs.getAll())[_token];

  @override
  Future<void> writeToken(value) async => await prefs.setValue('String', _token, value);
  
  @override
  Future<void> deleteToken() async => await prefs.remove(_token);
}

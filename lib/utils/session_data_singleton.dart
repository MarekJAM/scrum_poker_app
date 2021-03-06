import '../configurable/app_config.dart';
import 'storage/storage_wrapper.dart';

class SessionDataSingleton {
  static final SessionDataSingleton _singleton =
      SessionDataSingleton._internal();

  factory SessionDataSingleton() {
    return _singleton;
  }

  SessionDataSingleton._internal() {
    _storageWrapper = StorageWrapper();
  }

  String _token;
  String _username;
  String _serverAddress;
  StorageWrapper _storageWrapper;

  Future<void> init() async {
    _token = await _storageWrapper.readToken();
    _username = await _storageWrapper.readUsername();
    _serverAddress = await _storageWrapper.readServerAddress();
  }

  String getToken() {
    return _token;
  }

  Future<void> setToken(String token) async {
    _token = token;
    await _storageWrapper.writeToken(token);
  }

  String getUsername() {
    return _username;
  }

  Future<void> setUsername(String username) async {
    _username = username;
    await _storageWrapper.writeUsername(username);
  }

  String getServerAddress() {
    return _serverAddress ?? "${AppConfig.serverIp}:${AppConfig.port}";
  }

  Future<void> setServerAddress(String url) async {
    _serverAddress = url;
    await _storageWrapper.writeServerAddress(url);
  }
}

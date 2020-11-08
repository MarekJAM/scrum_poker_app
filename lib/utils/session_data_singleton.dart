import 'storage/storage_wrapper.dart';

class SessionDataSingleton {
  static final SessionDataSingleton _singleton = SessionDataSingleton._internal();

  factory SessionDataSingleton() {
    return _singleton;
  }

  SessionDataSingleton._internal();

  String _token;
  String _username;
  String _serverAddress;

  Future<void> init() async {
    _token = await StorageWrapper().readToken();
    _username = await StorageWrapper().readUsername();
    _serverAddress = await StorageWrapper().readServerAddress();
  }

  String getToken() {
    return _token;
  }

  Future<void> setToken(String token) async {
    _token = token;
    await StorageWrapper().writeToken(token);
  }

  String getUsername() {
    return _username;
  }

  Future<void> setUsername(String username) async {
    _username = username;
    await StorageWrapper().writeUsername(username);
  } 

  String getServerAddress() {
    return _serverAddress;
  }

  Future<void> setServerAddress(String url) async {
    _serverAddress = url;
    await StorageWrapper().writeServerAddress(url);
  }
}

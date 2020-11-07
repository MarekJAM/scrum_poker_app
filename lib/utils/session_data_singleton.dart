import 'secure_storage.dart';

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
    _token = await SecureStorage().readToken();
    _username = await SecureStorage().readUsername();
    _serverAddress = await SecureStorage().readServerAddress();
  }

  String getToken() {
    return _token;
  }

  Future<void> setToken(String token) async {
    _token = token;
    await SecureStorage().writeToken(token);
  }

  String getUsername() {
    return _username;
  }

  Future<void> setUsername(String username) async {
    _username = username;
    await SecureStorage().writeUsername(username);
  } 

  String getServerAddress() {
    return _serverAddress;
  }

  Future<void> setServerAddress(String url) async {
    _serverAddress = url;
    await SecureStorage().writeServerAddress(url);
  }
}

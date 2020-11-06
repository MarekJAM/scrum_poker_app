import 'secure_storage.dart';

class SesionDataSingleton {
  static final SesionDataSingleton _singleton = SesionDataSingleton._internal();

  factory SesionDataSingleton() {
    return _singleton;
  }

  SesionDataSingleton._internal();

  String _token;
  String _username;
  String _serverURL;

  init() async {
    _token = await SecureStorage().readToken();
    _username = await SecureStorage().readUsername();
    _serverURL = await SecureStorage().readServerAddress();
  }

  String getToken() {
    return _token;
  }

  void setToken(String token) async {
    _token = token;
    await SecureStorage().writeToken(token);
  }

  String getUsername() {
    return _username;
  }

  void setUsername(String username) async {
    _username = username;
    await SecureStorage().writeUsername(username);
  } 

  String getServerURL() {
    return _serverURL;
  }

  void setServerURL(String url) async {
    _serverURL = url;
    await SecureStorage().writeServerAddress(url);
  }
}

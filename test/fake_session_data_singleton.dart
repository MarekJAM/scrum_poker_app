import 'package:mockito/mockito.dart';

import '../lib/utils/session_data_singleton.dart';

class FakeSessionDataSingleton extends Fake implements SessionDataSingleton {
  @override
  Future<void> init() async {}

  @override
  String getServerAddress() {
    return "127.0.0.1";
  }

  Future<void> setServerAddress(String url) async {}

  @override
  String getUsername() {
    return "username";
  }

  Future<void> setUsername(String username) async {}

  @override
  String getToken() {
    return "token";
  }

  Future<void> setToken(String token) async {}

  @override
  String getAppVersion() {
    return "1.0";
  }
}
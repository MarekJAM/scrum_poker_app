import 'dart:io';

import 'package:http/http.dart' as http;

import 'repositories.dart';
import '../../data/models/models.dart';
import '../../utils/session_data_singleton.dart';

class AuthApiClient extends ApiClient {
  final _loginEndpoint = '/auth/login';
  final _registerEndpoint = '/auth/register';

  final http.Client httpClient;

  AuthApiClient({this.httpClient, SessionDataSingleton sessionDataSingleton})
      : assert(httpClient != null),
        super(sessionDataSingleton: sessionDataSingleton);

  Future<bool> login(String username, String password) async {
    http.Response response = await httpClient
        .post(getBaseURL() + '$_loginEndpoint',
            headers: {"Content-Type": "application/json"},
            body: OutgoingMessage.createLoginMessage(username, password))
        .timeout(const Duration(seconds: 5),
            onTimeout: () => throw SocketException("Login timeout."));

    if (response.statusCode != 200) {
      throwException(
          response.statusCode, decodeErrorMessage(response) ?? "Login failed");
    }

    var token = jsonParse(response)['token'];

    await SessionDataSingleton().setToken(token);

    return true;
  }

  Future<bool> register(String username, String password) async {
    http.Response response = await httpClient
        .post(getBaseURL() + '$_registerEndpoint',
            headers: {"Content-Type": "application/json"},
            body: OutgoingMessage.createLoginMessage(username, password))
        .timeout(const Duration(seconds: 5),
            onTimeout: () => throw SocketException("Register timeout."));

    if (response.statusCode != 201) {
      throwException(response.statusCode,
          decodeErrorMessage(response) ?? "Register failed");
    }

    return true;
  }
}

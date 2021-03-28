import 'dart:io';

import 'package:http/http.dart' as http;

import 'repositories.dart';
import '../../data/models/models.dart';
import '../../utils/session_data_singleton.dart';

class AuthApiClient extends ApiClient {
  final _loginEndpoint = '/auth/login';
  final _loginAsGuestEndpoint = '/auth/login/guest';
  final _registerEndpoint = '/auth/register';
  final _authRecoveryStepOne = '/auth/recovery';
  final _authRecoveryStepTwo = '/auth/recovery/answer';
  final _authRecoveryStepThree = '/auth/recovery/password';

  final http.Client httpClient;

  AuthApiClient({this.httpClient, SessionDataSingleton sessionDataSingleton})
      : assert(httpClient != null),
        super(sessionDataSingleton: sessionDataSingleton);

  Future<bool> loginWithCredentials(String username, String password) async {
    http.Response response = await httpClient
        .post(
          getBaseURL() + '$_loginEndpoint',
          headers: {"Content-Type": "application/json"},
          body: OutgoingMessage.createLoginMessage(username, password),
        )
        .timeout(
          const Duration(seconds: 5),
          onTimeout: () => throw SocketException("Login timeout."),
        );

    if (response.statusCode != 200) {
      throwException(response.statusCode, decodeErrorMessage(response) ?? "Login failed");
    }

    var token = jsonParse(response)['token'];

    await super.sessionDataSingleton.setToken(token);

    return true;
  }

  Future<bool> loginAsGuest(String username) async {
    http.Response response = await httpClient
        .post(
          getBaseURL() + '$_loginAsGuestEndpoint',
          headers: {"Content-Type": "application/json"},
          body: OutgoingMessage.createLoginAsGuestMessage(username),
        )
        .timeout(
          const Duration(seconds: 5),
          onTimeout: () => throw SocketException("Login timeout."),
        );

    if (response.statusCode != 200) {
      throwException(response.statusCode, decodeErrorMessage(response) ?? "Login failed");
    }

    var token = jsonParse(response)['token'];

    await super.sessionDataSingleton.setToken(token);

    return true;
  }

  Future<bool> register(String username, String password, String securityQuestion, String answer) async {
    http.Response response = await httpClient
        .post(
          getBaseURL() + '$_registerEndpoint',
          headers: {"Content-Type": "application/json"},
          body: OutgoingMessage.createRegisterMessage(username, password, securityQuestion, answer),
        )
        .timeout(
          const Duration(seconds: 5),
          onTimeout: () => throw SocketException("Register timeout."),
        );

    if (response.statusCode != 201) {
      throwException(response.statusCode, decodeErrorMessage(response) ?? "Register failed");
    }

    return true;
  }

  Future<RecoveryMessage> recoverStepOne(String username) async {
    http.Response response = await httpClient
        .post(getBaseURL() + '$_authRecoveryStepOne',
            headers: {"Content-Type": "application/json"},
            body: OutgoingMessage.createGetRecoveryTokenMessage(username))
        .timeout(
          const Duration(seconds: 5),
          onTimeout: () => throw SocketException("Recovery timeout."),
        );

    if (response.statusCode != 200) {
      throwException(response.statusCode, decodeErrorMessage(response) ?? "Recovery failed");
    }

    return RecoveryMessage.fromJson(jsonParse(response));
  }

  Future<String> recoverStepTwo(String token, String answer) async {
    http.Response response = await httpClient
        .post(
          getBaseURL() + '$_authRecoveryStepTwo',
          headers: getRequestHeaders(token),
          body: OutgoingMessage.createSendRecoveryAnswerMessage(answer),
        )
        .timeout(
          const Duration(seconds: 5),
          onTimeout: () => throw SocketException("Recovery timeout."),
        );

    if (response.statusCode != 200) {
      throwException(response.statusCode, decodeErrorMessage(response) ?? "Recovery failed");
    }

    return jsonParse(response)['token'];
  }

  Future<void> recoverStepThree(String token, String password) async {
    http.Response response = await httpClient
        .patch(
          getBaseURL() + '$_authRecoveryStepThree',
          headers: getRequestHeaders(token),
          body: OutgoingMessage.createSendRecoveryPasswordMessage(password),
        )
        .timeout(
          const Duration(seconds: 5),
          onTimeout: () => throw SocketException("Recovery timeout."),
        );

    if (response.statusCode != 200) {
      throwException(response.statusCode, decodeErrorMessage(response) ?? "Recovery failed");
    }
  }
}

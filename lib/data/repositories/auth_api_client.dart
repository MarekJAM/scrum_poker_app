import 'repositories.dart';
import 'package:http/http.dart' as http;

import '../../utils/secure_storage.dart';
import '../../data/models/models.dart';

class AuthApiClient extends ApiClient {
  final _loginEndpoint = '/auth/login';
  final _registerEndpoint = '/auth/register';

  final http.Client httpClient;

  AuthApiClient({this.httpClient, SecureStorage secureStorage})
      : assert(httpClient != null),
        super(secureStorage: secureStorage);

  Future<bool> login(String username, String password) async {
    http.Response response = await httpClient.put(
        getServerUrl() + '$_loginEndpoint',
        headers: {"Content-Type": "application/json"},
        body: OutgoingMessage.createLoginMessage(username, password));

    if (response.statusCode != 201) {
      throwException(
          response.statusCode, decodeErrorMessage(response) ?? "Login failed");
    }

    var token = jsonParse(response)['token'];

    await saveToken(token);

    return true;
  }
}

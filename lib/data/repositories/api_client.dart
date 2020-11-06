import 'dart:convert';
import 'exceptions.dart';

import '../../utils/secure_storage.dart';
import '../../utils/session_data_singleton.dart';

class ApiClient {
  ApiClient({SecureStorage secureStorage})
      : _secureStorage = secureStorage ?? SecureStorage();

  final SecureStorage _secureStorage;

  void throwException(int statusCode, String message) {
    if (statusCode == 400) {
      throw BadRequestException(message, statusCode);
    } else if (statusCode == 401) {
      throw UnauthorizedException(message, statusCode);
    } else if (statusCode == 404) {
      throw NotFoundException(message, statusCode);
    } else if (statusCode == 409) {
      throw ResourceExistsException(message, statusCode);
    } else if (statusCode > 400 && statusCode < 500) {
      throw ClientException(message, statusCode);
    } else if (statusCode > 500) {
      throw ServerException(message, statusCode);
    } else {
      throw Exception('$message, status code: $statusCode');
    }
  }

  Map<String, String> getRequestHeaders() {
    return {
      "Content-Type": "application/json",
      "Authorization": 'Bearer ' + SesionDataSingleton().getToken()
    };
  }

  String decodeErrorMessage(response) {
    if (response.body == null) {
      return null;
    }
    return json.decode(response.body)['message'] ?? null;
  }

  dynamic jsonParse(response) {
    return jsonDecode(utf8.decode(response.bodyBytes));
  }
}

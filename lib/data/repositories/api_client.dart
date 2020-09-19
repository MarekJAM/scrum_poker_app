import 'dart:convert';
import 'exceptions.dart';
import '../../utils/secure_storage.dart';

class ApiClient {
  ApiClient({SecureStorage secureStorage}) : _secureStorage = secureStorage ?? SecureStorage();

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

  String decodeErrorMessage(response) {
    return json.decode(response.body)['message'] ?? null;
  }

  Future<String> getServerUrl() async {
    return 'http://' + await _secureStorage.readServerAddress();
  }

  Future<String> getUsername() async {
    return await _secureStorage.readUsername();
  }

}

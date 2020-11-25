import 'dart:convert';

import 'package:flutter_translate/flutter_translate.dart';

import 'exceptions.dart';
import '../../utils/session_data_singleton.dart';

class ApiClient {
  ApiClient({SessionDataSingleton sessionDataSingleton})
      : _sessionDataSingleton = sessionDataSingleton ?? SessionDataSingleton();

  final SessionDataSingleton _sessionDataSingleton;

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
    } else if (statusCode >= 500) {
      throw ServerException(message, statusCode);
    } else {
      throw Exception('$message, status code: $statusCode');
    }
  }

  Map<String, String> getRequestHeaders() {
    return {
      "Content-Type": "application/json",
      "Authorization": 'Bearer ' + _sessionDataSingleton.getToken()
    };
  }

  String getBaseURL() {
    return 'http://' + _sessionDataSingleton.getServerAddress();
  }

  String decodeErrorMessage(response) {
    try {
      var message = translate(json.decode(response.body)['message']);
      return message;
    } catch (e) {
      print(e);
      return null;
    }
  }

  dynamic jsonParse(response) {
    return jsonDecode(utf8.decode(response.bodyBytes));
  }
}

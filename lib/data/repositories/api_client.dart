import 'exceptions.dart';

class ApiClient {
  void throwException(int statusCode, String message) {
    if (statusCode == 401) {
      throw UnauthorizedException('$message, status code: $statusCode');
    } else if (statusCode == 400) {
      throw BadRequestException('$message, status code: $statusCode');
    } else if (statusCode == 404) {
      throw NotFoundException('$message, status code: $statusCode');
    } else if (statusCode == 409) {
      throw ResourceExistsException('$message, status code: $statusCode');
    } else if (statusCode > 400 && 500 > statusCode) {
      throw ClientException('$message, status code: $statusCode');
    } else if (statusCode > 500) {
      throw ServerException('$message, status code: $statusCode');
    } else {
      throw Exception('$message, status code: $statusCode');
    }
  }
}

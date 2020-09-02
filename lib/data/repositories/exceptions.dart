abstract class BaseException implements Exception {
  final String message;
  final int statusCode;

  const BaseException([this.message = "", this.statusCode]);

  String toString() => "BaseException: $message, status code: $statusCode";
}

class BadRequestException extends BaseException {
  const BadRequestException([String message, int statusCode]) : super(message, statusCode);

  @override
  String toString() => "BadRequestException: $message, status code: $statusCode";
}

class UnauthorizedException extends BaseException {
  const UnauthorizedException([String message, int statusCode]) : super(message, statusCode);

  @override
  String toString() => "UnauthorizedException: $message, status code: $statusCode";
}

class NotFoundException extends BaseException {
  const NotFoundException([String message, int statusCode]) : super(message, statusCode);

  @override
  String toString() => "NotFoundException: $message, status code: $statusCode";
}

class ClientException extends BaseException {
  const ClientException([String message, int statusCode]) : super(message, statusCode);

  @override
  String toString() => "ClientException: $message, status code: $statusCode";
}

class ServerException extends BaseException {
  const ServerException([String message, int statusCode]) : super(message, statusCode);

  @override
  String toString() => "ServerException: $message, status code: $statusCode";
}

class ResourceExistsException extends BaseException {
  const ResourceExistsException([String message, int statusCode]) : super(message, statusCode);

  @override
  String toString() => "ResourceExistsException: $message, status code: $statusCode";
}
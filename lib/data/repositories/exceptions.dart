abstract class BaseException implements Exception {
  final String message;

  const BaseException([this.message = ""]);

  String toString() => "BaseException: $message";
}

class BadRequestException extends BaseException {
  const BadRequestException([String message]) : super(message);

  @override
  String toString() => "BadRequestException: $message";
}

class UnauthorizedException extends BaseException {
  const UnauthorizedException([String message]) : super(message);

  @override
  String toString() => "UnauthorizedException: $message";
}

class NotFoundException extends BaseException {
  const NotFoundException([String message]) : super(message);

  @override
  String toString() => "NotFoundException: $message";
}

class ClientException extends BaseException {
  const ClientException([String message]) : super(message);

  @override
  String toString() => "ClientException: $message";
}

class ServerException extends BaseException {
  const ServerException([String message]) : super(message);

  @override
  String toString() => "ServerException: $message";
}

class ResourceExistsException extends BaseException {
  const ResourceExistsException([String message]) : super(message);

  @override
  String toString() => "ResourceExistsException: $message";
}
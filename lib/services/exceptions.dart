class ExtAppException implements Exception {
  final dynamic message;
  final dynamic details;

  ExtAppException([this.message, this.details]);

  @override
  String toString() {
    return message?.toString() ?? 'Ошибка в работе приложения';
  }
}

class UnauthorizedException implements Exception {
  final message = 'Unauthorized';

  @override
  String toString() => message;
}

class IncorrectApiVersionException implements Exception {
  final message = 'Incorrect API version';

  @override
  String toString() => message;
}

class AppException implements Exception {
  final String message;
  final String prefix;
  final String url;

  AppException(this.message, this.prefix, this.url);

  @override
  String toString() {
    return '$prefix$message';
  }
}

class FetchDataException extends AppException {
  FetchDataException(String message, String url)
      : super(message, 'Error During Communication: ', url);
}

class BadRequestException extends AppException {
  BadRequestException(String message, String url)
      : super(message, 'Invalid Request: ', url);
}

class UnauthorisedException extends AppException {
  UnauthorisedException(String message, String url)
      : super(message, 'Unauthorised: ', url);
}

class InvalidInputException extends AppException {
  InvalidInputException(String message, String url)
      : super(message, 'Invalid Input: ', url);
}
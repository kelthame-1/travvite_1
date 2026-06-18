class ServerException implements Exception {
final String message;
const ServerException(this.message);

@override
String toString() => message;
}

class NetworkException implements Exception {
final String message;
const NetworkException(this.message);

@override
String toString() => message;
}

class NetworkTimeoutException implements Exception {
final String message;
const NetworkTimeoutException(this.message);

@override
String toString() => message;
}

class SessionException implements Exception {
final String message;
const SessionException(this.message);

@override
String toString() => message;
}

class ValidationException implements Exception {
final String message;
const ValidationException(this.message);

@override
String toString() => message;
}

class NotFoundException implements Exception { // 🆕
final String message;
const NotFoundException(this.message);

@override
String toString() => message;
}

class UnauthorizedException implements Exception { // 🆕
final String message;
const UnauthorizedException(this.message);

@override
String toString() => message;
}

class CacheException implements Exception { // 🆕
final String message;
const CacheException(this.message);

@override
String toString() => message;
}
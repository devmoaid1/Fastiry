import 'package:equatable/equatable.dart';

class ServerException extends Equatable implements Exception {
  final String message;

  ServerException([this.message]);
  @override
  List<Object> get props => [message];
  @override
  String toString() {
    return message;
  }
}

class FetchDataException extends ServerException {
  FetchDataException([message]) : super("Error During Communication");
}

class BadRequestException extends ServerException {
  BadRequestException([message]) : super("Bad Request");
}

class UnauthorizedException extends ServerException {
  UnauthorizedException([message]) : super("Unauthorized");
}

class NotFoundException extends ServerException {
  NotFoundException([message]) : super("Requested Info Not Found");
}

class ConflictException extends ServerException {
  ConflictException([message]) : super("Conflict Occurred");
}

class InternalServerErrorException extends ServerException {
  InternalServerErrorException([message]) : super("Internal Server Error");
}

class NoInternetConnectionException extends ServerException {
  NoInternetConnectionException([message]) : super("No Internet Connection");
}

class CacheException implements Exception {}

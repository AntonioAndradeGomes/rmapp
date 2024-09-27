import 'package:equatable/equatable.dart';

class HttpException extends Equatable implements Exception {
  final int? statusCode;
  final String message;
  final dynamic data;

  const HttpException({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  @override
  List<Object?> get props => [
        statusCode,
        message,
        data,
      ];
}

import 'package:dio/dio.dart';

class HttpResponse {
  final int statusCode;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? headers;

  HttpResponse({
    required this.statusCode,
    required this.data,
    required this.headers,
  });
}

abstract class HttpClient {
  Future<HttpResponse> get({
    required String url,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });
}

class DioHttpClient implements HttpClient {
  final Dio _dio;

  DioHttpClient({required Dio dio}) : _dio = dio;

  @override
  Future<HttpResponse> get({
    required String url,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
        ),
      );
      return HttpResponse(
        statusCode: response.statusCode ?? 500,
        data: response.data,
        headers: response.headers.map,
      );
    } on DioException catch (e) {
      //a fazer
      rethrow;
    }
  }
}
